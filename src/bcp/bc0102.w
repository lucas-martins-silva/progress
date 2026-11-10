&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI &THEN
&ANALYZE-RESUME
/* Connected Databases 
          mgcld            PROGRESS
*/
&Scoped-define WINDOW-NAME wMasterDetail

/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE ttBcLayout NO-UNDO LIKE bc-layout
            FIELD RowNum AS INTEGER INITIAL 1
            FIELD r-Rowid AS ROWID
            INDEX iSeq AS PRIMARY RowNum.

DEFINE TEMP-TABLE ttBcLayoutRegistro NO-UNDO LIKE bc-layout-registro
            FIELD RowNum AS INTEGER INITIAL 1
            FIELD r-Rowid AS ROWID
            INDEX iSeq AS PRIMARY RowNum.


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS wMasterDetail 
/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i BC0102 2.00.00.029}  /*** "010029" 14/08/2023 08:00:45  ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
   {include/i-license-manager.i bc0102 MBC}
&ENDIF

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS wMasterDetail 
/********************************************************************************
** Copyright DATASUL S.A. (1999)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/

CREATE WIDGET-POOL.

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program          BC0102
&GLOBAL-DEFINE Version          2.00.00.029

&GLOBAL-DEFINE Folder           YES
&GLOBAL-DEFINE InitialPage      1
&GLOBAL-DEFINE FolderLabels     Estrutura

&GLOBAL-DEFINE First            YES
&GLOBAL-DEFINE Prev             YES
&GLOBAL-DEFINE Next             YES
&GLOBAL-DEFINE Last             YES
&GLOBAL-DEFINE GoTo             YES
&GLOBAL-DEFINE Search           YES

&GLOBAL-DEFINE AddParent        YES
&GLOBAL-DEFINE CopyParent       YES
&GLOBAL-DEFINE UpdateParent     NO
&GLOBAL-DEFINE DeleteParent     NO

&GLOBAL-DEFINE ttParent         ttBcLayout
&GLOBAL-DEFINE hDBOParent       hDBOBcLayout
&GLOBAL-DEFINE DBOParentTable   bc-layout
&GLOBAL-DEFINE DBOParentDestroy NO

&GLOBAL-DEFINE ttSon1           ttBcLayoutRegistro
&GLOBAL-DEFINE hDBOSon1         hDBOLayoutRegistro
&GLOBAL-DEFINE DBOSon1Table     Bc-Layout-Registro
&GLOBAL-DEFINE DBOSon1Destroy   NO

&GLOBAL-DEFINE page0Fields      ttBcLayout.cod-layout ~
                                ttBcLayout.descricao ~
                                ttBcLayout.log-datasul ~
                                ttBcLayout.num-versao

&GLOBAL-DEFINE ROW-NUM-DEFINED1 YES
&GLOBAL-DEFINE ROW-NUM-DEFINED2 YES

{cdp/cdcfgint.i}
&glob SeparadorLinhas   Separador-Linhas
{include/i_fnctrad.i}

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */
DEFINE VARIABLE iTreeViewID         AS INTEGER NO-UNDO.

/* Local Variable Definitions (DBOs Handles) ---                        */
DEFINE VARIABLE {&hDBOParent}       AS HANDLE      NO-UNDO.
DEFINE VARIABLE {&hDBOSon1}         AS HANDLE      NO-UNDO.
DEFINE VARIABLE hDBOBcLayoutRegItem AS HANDLE      NO-UNDO.
DEFINE VARIABLE hDBOBcTpLayoutReg   AS HANDLE      NO-UNDO.
DEFINE VARIABLE hDBOBcTpLayoutTab   AS HANDLE      NO-UNDO.
DEFINE VARIABLE hDBOBcTpLayout      AS HANDLE      NO-UNDO.
DEFINE VARIABLE h-bc0102b           AS HANDLE      NO-UNDO.
DEFINE VARIABLE h-bc0102c           AS HANDLE      NO-UNDO.
DEFINE VARIABLE h-bc0102d           AS HANDLE      NO-UNDO.
DEFINE VARIABLE h-bc0102e           AS HANDLE      NO-UNDO.
DEFINE VARIABLE c-parent-node       AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-tag-node          AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-evento-node       AS CHARACTER   NO-UNDO.
DEFINE VARIABLE lok                 AS LOGICAL     NO-UNDO.
DEFINE VARIABLE iCodTpLayoutReg     AS INTEGER     NO-UNDO. /* 1 - Cabec, 2 - Itens, 3 - RodapÇ... */
DEFINE VARIABLE iIndOcorrencia      AS INTEGER     NO-UNDO. /* 1 - Ènica, 2 - M£ltipla             */
DEFINE VARIABLE cDesLabel           AS CHARACTER   NO-UNDO. /* Label para Visualizacao no TreeView */
DEFINE VARIABLE iTipoAcao           AS INTEGER     NO-UNDO.
DEFINE VARIABLE iTipoItem           AS INTEGER     NO-UNDO. /* Indica o Tipo de Item - 0-Segmento 1-Campo 2-Constante 3-Nova Linha 4-Espaáo 5-Auxiliar 6-Campo Fixo */
DEFINE VARIABLE cConst              AS CHARACTER   NO-UNDO.
DEFINE VARIABLE cLiteral            AS CHARACTER   NO-UNDO.
DEFINE VARIABLE cValorItem          AS CHARACTER   NO-UNDO.
DEFINE VARIABLE iNumSeqReg          AS INTEGER     NO-UNDO.
DEFINE VARIABLE iNumSeqRegSeg       AS INTEGER     NO-UNDO.
DEFINE VARIABLE iNumLayoutReg       AS INTEGER     NO-UNDO.
DEFINE VARIABLE iNumItem            AS INTEGER     NO-UNDO.
DEFINE VARIABLE cDesDtbaseTable     AS CHARACTER   NO-UNDO.  
DEFINE VARIABLE cDesField           AS CHARACTER   NO-UNDO.
DEFINE VARIABLE hBuffer             AS HANDLE      NO-UNDO.
DEFINE VARIABLE hField              AS HANDLE      NO-UNDO.
DEFINE VARIABLE iNumField           AS INTEGER     NO-UNDO.
DEFINE VARIABLE cFieldExtent        AS CHARACTER   NO-UNDO. /* Atributo Selecionado Extent      */  
DEFINE VARIABLE cField              AS CHARACTER   NO-UNDO. /* Atributo Selecionado             */
DEFINE VARIABLE iCont               AS INTEGER     NO-UNDO.
DEFINE VARIABLE c-inicial-aux       AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-final-aux         AS CHARACTER   NO-UNDO.
DEFINE VARIABLE iCodTpLayReg        AS INTEGER     NO-UNDO. /* Tipo Layout Registro do Segmento */
DEFINE VARIABLE cComplemento        AS CHARACTER   NO-UNDO.
DEFINE VARIABLE cDescricao          AS CHARACTER   NO-UNDO.
DEFINE VARIABLE iNumAux             AS INTEGER     NO-UNDO.
DEFINE VARIABLE iSeqReg             AS INTEGER     NO-UNDO.
DEFINE VARIABLE icodTipolayout      AS INTEGER     NO-UNDO.

{bcp/bc0102.i}

DEFINE TEMP-TABLE ttRegEstr-aux NO-UNDO LIKE ttRegEstr.

DEFINE TEMP-TABLE tt-estrut-tab NO-UNDO
            FIELD sequencia  AS INTEGER   FORMAT '>>>>9':U
            FIELD titulo     AS CHARACTER FORMAT 'x(20)':U
            FIELD titulo-col AS CHARACTER FORMAT 'x(20)':U
            FIELD atributo   AS CHARACTER FORMAT 'x(100)':U
            FIELD formato    AS CHARACTER FORMAT 'x(30)':U
            FIELD tipo-dado  AS CHARACTER FORMAT 'x(30)':U.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE MasterDetail
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fPage0

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS ttBcLayout.cod-layout ttBcLayout.descricao ~
ttBcLayout.log-datasul ttBcLayout.num-versao 
&Scoped-define ENABLED-TABLES ttBcLayout
&Scoped-define FIRST-ENABLED-TABLE ttBcLayout
&Scoped-define DISPLAYED-TABLES ttBcLayout
&Scoped-define FIRST-DISPLAYED-TABLE ttBcLayout
&Scoped-Define ENABLED-OBJECTS btFirst btPrev btNext btLast btGoTo btSearch ~
btAdd btCopy btUpdate btDelete btCancel btSave btQueryJoins btReportsJoins ~
btExit btHelp cDesTipoLayout cSeparadorLinhas cIndLeituraCampo ~
cSeparadorCampos RECT-4 rtParent rtToolBar 
&Scoped-Define DISPLAYED-FIELDS ttBcLayout.cod-layout ttBcLayout.descricao ~
ttBcLayout.log-datasul ttBcLayout.num-versao 
&Scoped-Define DISPLAYED-OBJECTS cDesTipoLayout cSeparadorLinhas ~
cIndLeituraCampo cSeparadorCampos 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR wMasterDetail AS WIDGET-HANDLE NO-UNDO.

/* Menu Definitions                                                     */
DEFINE SUB-MENU smFile 
       MENU-ITEM miFirst        LABEL "&Primeiro"      ACCELERATOR "CTRL-HOME"
       MENU-ITEM miPrev         LABEL "&Anterior"      ACCELERATOR "CTRL-CURSOR-LEFT"
       MENU-ITEM miNext         LABEL "&Pr¢ximo"       ACCELERATOR "CTRL-CURSOR-RIGHT"
       MENU-ITEM miLast         LABEL "&Èltimo"        ACCELERATOR "CTRL-END"
       RULE
       MENU-ITEM miGoTo         LABEL "&V† Para"       ACCELERATOR "CTRL-T"
       MENU-ITEM miSearch       LABEL "&Pesquisa"      ACCELERATOR "CTRL-F5"
       RULE
       MENU-ITEM miAdd          LABEL "&Incluir"       ACCELERATOR "CTRL-INS"
       MENU-ITEM miCopy         LABEL "&Copiar"        ACCELERATOR "CTRL-C"
       MENU-ITEM miUpdate       LABEL "&Alterar"       ACCELERATOR "CTRL-A"
       MENU-ITEM miDelete       LABEL "&Eliminar"      ACCELERATOR "CTRL-DEL"
       RULE
       MENU-ITEM miCancel       LABEL "&Cancelar"      ACCELERATOR "CTRL-F4"
       MENU-ITEM miSave         LABEL "&Salvar"        ACCELERATOR "CTRL-S"
       RULE
       MENU-ITEM miQueryJoins   LABEL "&Consultas"    
       MENU-ITEM miReportsJoins LABEL "&Relat¢rios"   
       RULE
       MENU-ITEM miExit         LABEL "&Sair"          ACCELERATOR "CTRL-X".

DEFINE SUB-MENU smHelp 
       MENU-ITEM miContents     LABEL "&Conte£do"     
       RULE
       MENU-ITEM miAbout        LABEL "&Sobre..."     .

DEFINE MENU mbMain MENUBAR
       SUB-MENU  smFile         LABEL "&Arquivo"      
       SUB-MENU  smHelp         LABEL "&Ajuda"        .

/* Eventos treeview*/
{utp/ut-4gltreeview.i}

/* Definitions of the field level widgets                               */
DEFINE BUTTON btAdd 
     IMAGE-UP FILE "image~\im-add":U
     IMAGE-INSENSITIVE FILE "image~\ii-add":U
     LABEL "Add" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE BUTTON btCancel 
     IMAGE-UP FILE "image~\im-can":U
     IMAGE-INSENSITIVE FILE "image~\im-can":U
     LABEL "Cancel" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE BUTTON btCopy 
     IMAGE-UP FILE "image~\im-copy":U
     IMAGE-INSENSITIVE FILE "image~\ii-copy":U
     LABEL "Copy" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE BUTTON btDelete 
     IMAGE-UP FILE "image~\im-era":U
     IMAGE-INSENSITIVE FILE "image~\ii-era":U
     LABEL "Delete" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE BUTTON btExit 
     IMAGE-UP FILE "image~\im-exi":U
     IMAGE-INSENSITIVE FILE "image~\ii-exi":U
     LABEL "Exit" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE BUTTON btFirst 
     IMAGE-UP FILE "image~\im-fir":U
     IMAGE-INSENSITIVE FILE "image~\ii-fir":U
     LABEL "First":L 
     SIZE 4 BY 1.25.

DEFINE BUTTON btGoTo 
     IMAGE-UP FILE "image~\im-enter":U
     IMAGE-INSENSITIVE FILE "image~\ii-enter":U
     LABEL "Go To" 
     SIZE 4 BY 1.25.

DEFINE BUTTON btHelp 
     IMAGE-UP FILE "image~\im-hel":U
     IMAGE-INSENSITIVE FILE "image~\ii-hel":U
     LABEL "Help" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE BUTTON btLast 
     IMAGE-UP FILE "image~\im-las":U
     IMAGE-INSENSITIVE FILE "image~\ii-las":U
     LABEL "Last":L 
     SIZE 4 BY 1.25.

DEFINE BUTTON btNext 
     IMAGE-UP FILE "image~\im-nex":U
     IMAGE-INSENSITIVE FILE "image~\ii-nex":U
     LABEL "Next":L 
     SIZE 4 BY 1.25.

DEFINE BUTTON btPrev 
     IMAGE-UP FILE "image~\im-pre":U
     IMAGE-INSENSITIVE FILE "image~\ii-pre":U
     LABEL "Prev":L 
     SIZE 4 BY 1.25.

DEFINE BUTTON btQueryJoins 
     IMAGE-UP FILE "image~\im-joi":U
     IMAGE-INSENSITIVE FILE "image~\ii-joi":U
     LABEL "Query Joins" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE BUTTON btReportsJoins 
     IMAGE-UP FILE "image~\im-pri":U
     IMAGE-INSENSITIVE FILE "image~\ii-pri":U
     LABEL "Reports Joins" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE BUTTON btSave 
     IMAGE-UP FILE "image~\im-sav":U
     IMAGE-INSENSITIVE FILE "image~\ii-sav":U
     LABEL "Save" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE BUTTON btSearch 
     IMAGE-UP FILE "image~\im-sea":U
     IMAGE-INSENSITIVE FILE "image~\ii-sea":U
     LABEL "Search" 
     SIZE 4 BY 1.25.

DEFINE BUTTON btUpdate 
     IMAGE-UP FILE "image~\im-mod":U
     IMAGE-INSENSITIVE FILE "image~\ii-mod":U
     LABEL "Update" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE VARIABLE cDesTipoLayout AS CHARACTER FORMAT "X(30)":U 
     LABEL "" 
     VIEW-AS FILL-IN 
     SIZE 20 BY .88 NO-UNDO.

DEFINE VARIABLE cIndLeituraCampo AS CHARACTER FORMAT "X(30)":U 
     LABEL "" 
     VIEW-AS FILL-IN 
     SIZE 20 BY .88 NO-UNDO.

DEFINE VARIABLE cSeparadorCampos AS CHARACTER FORMAT "X(8)":U 
     LABEL "" 
     VIEW-AS FILL-IN 
     SIZE 9.29 BY .88 NO-UNDO.

DEFINE VARIABLE cSeparadorLinhas AS CHARACTER FORMAT "X(8)":U 
     LABEL "" 
     VIEW-AS FILL-IN 
     SIZE 9.29 BY .88 NO-UNDO.

DEFINE RECTANGLE RECT-4
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 90 BY 2.33.

DEFINE RECTANGLE rtParent
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 90 BY 2.25.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE  
     SIZE 90 BY 1.5
     BGCOLOR 7 .

DEFINE BUTTON btAuxiliar 
     LABEL "Auxiliar" 
     SIZE 9 BY 1.

DEFINE BUTTON btCampo 
     LABEL "Campo" 
     SIZE 9 BY 1.

DEFINE BUTTON btCampoLivre 
     LABEL "Campo Fixo" 
     SIZE 9 BY 1.

DEFINE BUTTON btConstante 
     LABEL "Constante" 
     SIZE 9 BY 1.

DEFINE BUTTON btElimina 
     LABEL "Elimina" 
     SIZE 9 BY 1.

DEFINE BUTTON btEspaco 
     LABEL "Espaáo" 
     SIZE 9 BY 1.

DEFINE BUTTON btLinha 
     LABEL "Linha" 
     SIZE 9 BY 1.

DEFINE BUTTON btModifica 
     LABEL "Modifica" 
     SIZE 9 BY 1.

DEFINE BUTTON btSegmento 
     LABEL "Segmento" 
     SIZE 9 BY 1.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fPage0
     btFirst AT ROW 1.13 COL 1.57 HELP
          "Primeira ocorrància"
     btPrev AT ROW 1.13 COL 5.57 HELP
          "Ocorrància anterior"
     btNext AT ROW 1.13 COL 9.57 HELP
          "Pr¢xima ocorrància"
     btLast AT ROW 1.13 COL 13.57 HELP
          "Èltima ocorrància"
     btGoTo AT ROW 1.13 COL 17.57 HELP
          "V† Para"
     btSearch AT ROW 1.13 COL 21.57 HELP
          "Pesquisa"
     btAdd AT ROW 1.13 COL 31 HELP
          "Inclui nova ocorrància"
     btCopy AT ROW 1.13 COL 35 HELP
          "Cria uma c¢pia da ocorrància corrente"
     btUpdate AT ROW 1.13 COL 39 HELP
          "Altera ocorrància corrente"
     btDelete AT ROW 1.13 COL 43 HELP
          "Elimina ocorrància corrente"
     btCancel AT ROW 1.13 COL 51 HELP
          "Cancela alteraá‰es"
     btSave AT ROW 1.13 COL 55 HELP
          "Confirma alteraá‰es"
     btQueryJoins AT ROW 1.13 COL 74.86 HELP
          "Consultas relacionadas"
     btReportsJoins AT ROW 1.13 COL 78.86 HELP
          "Relat¢rios relacionados"
     btExit AT ROW 1.13 COL 82.86 HELP
          "Sair"
     btHelp AT ROW 1.13 COL 86.86 HELP
          "Ajuda"
     ttBcLayout.cod-layout AT ROW 2.83 COL 22 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 5.72 BY .88
     ttBcLayout.descricao AT ROW 2.83 COL 28 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 35.43 BY .88
     ttBcLayout.log-datasul AT ROW 3.83 COL 24
          VIEW-AS TOGGLE-BOX
          SIZE 14 BY .71
     ttBcLayout.num-versao AT ROW 3.83 COL 59 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 4.43 BY .88
     cDesTipoLayout AT ROW 5.25 COL 22 COLON-ALIGNED
     cSeparadorLinhas AT ROW 5.25 COL 54.14 COLON-ALIGNED
     cIndLeituraCampo AT ROW 6.25 COL 22 COLON-ALIGNED
     cSeparadorCampos AT ROW 6.25 COL 54.14 COLON-ALIGNED
     RECT-4 AT ROW 5 COL 1
     rtParent AT ROW 2.67 COL 1
     rtToolBar AT ROW 1 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 91.43 BY 18.17
         FONT 1.

DEFINE FRAME fPage1
     btSegmento AT ROW 9.5 COL 2
     btCampo AT ROW 9.5 COL 11
     btConstante AT ROW 9.5 COL 20
     btLinha AT ROW 9.5 COL 29
     btEspaco AT ROW 9.5 COL 38
     btAuxiliar AT ROW 9.5 COL 47
     btCampoLivre AT ROW 9.5 COL 56
     btModifica AT ROW 9.5 COL 67
     btElimina AT ROW 9.5 COL 76
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.57 ROW 8.75
         SIZE 84.43 BY 9.75
         FONT 1.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: MasterDetail
   Allow: Basic,Browse,DB-Fields,Window,Query
   Add Fields to: Neither
   Other Settings: COMPILE
   Temp-Tables and Buffers:
      TABLE: ttBcLayout T "?" NO-UNDO mgcld bc-layout
      ADDITIONAL-FIELDS:
          FIELD RowNum AS INTEGER INITIAL 1
          FIELD r-Rowid AS ROWID
          INDEX iSeq AS PRIMARY RowNum
      END-FIELDS.
      TABLE: ttBcLayoutRegistro T "?" NO-UNDO mgcld bc-layout-registro
      ADDITIONAL-FIELDS:
          FIELD RowNum AS INTEGER INITIAL 1
          FIELD r-Rowid AS ROWID
          INDEX iSeq AS PRIMARY RowNum
      END-FIELDS.
   END-TABLES.
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW wMasterDetail ASSIGN
         HIDDEN             = YES
         TITLE              = ""
         HEIGHT             = 18.17
         WIDTH              = 91.43
         MAX-HEIGHT         = 19.08
         MAX-WIDTH          = 91.43
         VIRTUAL-HEIGHT     = 19.08
         VIRTUAL-WIDTH      = 91.43
         RESIZE             = YES
         SCROLL-BARS        = NO
         STATUS-AREA        = YES
         BGCOLOR            = ?
         FGCOLOR            = ?
         KEEP-FRAME-Z-ORDER = YES
         THREE-D            = YES
         MESSAGE-AREA       = NO
         SENSITIVE          = YES.
ELSE {&WINDOW-NAME} = CURRENT-WINDOW.

ASSIGN {&WINDOW-NAME}:MENUBAR    = MENU mbMain:HANDLE.
/* END WINDOW DEFINITION                                                */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB wMasterDetail 
/* ************************* Included-Libraries *********************** */

{masterdetail/masterdetail.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW wMasterDetail
  NOT-VISIBLE,,RUN-PERSISTENT                                           */
/* REPARENT FRAME */
ASSIGN FRAME fPage1:FRAME = FRAME fPage0:HANDLE.

/* SETTINGS FOR FRAME fPage0
   FRAME-NAME                                                           */
/* SETTINGS FOR FRAME fPage1
                                                                        */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wMasterDetail)
THEN wMasterDetail:HIDDEN = YES.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME fPage0
/* Query rebuild information for FRAME fPage0
     _Options          = "SHARE-LOCK KEEP-EMPTY"
     _Query            is NOT OPENED
*/  /* FRAME fPage0 */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME fPage1
/* Query rebuild information for FRAME fPage1
     _Query            is NOT OPENED
*/  /* FRAME fPage1 */
&ANALYZE-RESUME

/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME wMasterDetail
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wMasterDetail wMasterDetail
ON END-ERROR OF wMasterDetail
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
   /* This case occurs when the user presses the "Esc" key.
      In a persistently run window, just ignore this.  If we did not, the
      application would exit. */
   IF THIS-PROCEDURE:PERSISTENT THEN
      RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wMasterDetail wMasterDetail
ON WINDOW-CLOSE OF wMasterDetail
DO:
   /* This event will close the window and terminate the procedure.  */
   APPLY "CLOSE":U TO THIS-PROCEDURE.
   RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btAdd
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btAdd wMasterDetail
ON CHOOSE OF btAdd IN FRAME fPage0 /* Add */
OR CHOOSE OF MENU-ITEM miAdd IN MENU mbMain DO:
   RUN addRecord IN THIS-PROCEDURE (INPUT "bcp/bc0102a.w":U). 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage1
&Scoped-define SELF-NAME btAuxiliar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btAuxiliar wMasterDetail
ON CHOOSE OF btAuxiliar IN FRAME fPage1 /* Auxiliar */
DO:
   ASSIGN iTipoItem = 5.
   RUN criaAuxiliarCampoLivre. /* tipoItem */
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btCampo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btCampo wMasterDetail
ON CHOOSE OF btCampo IN FRAME fPage1 /* Campo */
DO:
   ASSIGN iTipoItem = 1.
   RUN selecionaCampo IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btCampoLivre
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btCampoLivre wMasterDetail
ON CHOOSE OF btCampoLivre IN FRAME fPage1 /* Campo Fixo */
DO:
   ASSIGN iTipoItem = 6.
   
   /* Pergunta ao usuario se deseja criar nova versao do Bc-Layout */
   RUN utp/ut-msgs.p('SHOW':U,
                     26121,
                     '':U).
   IF RETURN-VALUE = "YES":U THEN DO:
      RUN selecionaCampo IN THIS-PROCEDURE.
   END.
   ELSE DO:
      RUN criaAuxiliarCampoLivre. /* tipoItem */
   END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage0
&Scoped-define SELF-NAME btCancel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btCancel wMasterDetail
ON CHOOSE OF btCancel IN FRAME fPage0 /* Cancel */
OR CHOOSE OF MENU-ITEM miCancel IN MENU mbMain DO:
   RUN controlButtons IN THIS-PROCEDURE (NO).

   /* Mostra estrutura anterior */
   SESSION:SET-WAIT-STATE("general":U).
   RUN obtemEstrutura IN {&hDBOSon1} (INPUT hDBOBcLayout,
                                      INPUT hDBOBcLayoutRegItem,
                                      INPUT hDBOBcTpLayoutReg,
                                      OUTPUT TABLE ttRegEstr).
                                      
   RUN emptyTree IN h-4gltreeview NO-ERROR.
   
   RUN mostraEstrutura.
   
   RUN pi-atualizaTreeview IN THIS-PROCEDURE.   
   
   RUN applyEntry IN h-4gltreeview(INPUT "").    
   
   SESSION:SET-WAIT-STATE("":U).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage1
&Scoped-define SELF-NAME btConstante
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btConstante wMasterDetail
ON CHOOSE OF btConstante IN FRAME fPage1 /* Constante */
DO:
   ASSIGN iTipoItem = 2.
   RUN criaConstLinhaEspaco. /* tipoItem */
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage0
&Scoped-define SELF-NAME btCopy
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btCopy wMasterDetail
ON CHOOSE OF btCopy IN FRAME fPage0 /* Copy */
OR CHOOSE OF MENU-ITEM miCopy IN MENU mbMain DO:
   RUN copyRecord (INPUT "bcp/bc0102a.w":U).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btDelete
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btDelete wMasterDetail
ON CHOOSE OF btDelete IN FRAME fPage0 /* Delete */
OR CHOOSE OF MENU-ITEM miDelete IN MENU mbMain DO:
   RUN deleteRecord IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage1
&Scoped-define SELF-NAME btElimina
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btElimina wMasterDetail
ON CHOOSE OF btElimina IN FRAME fPage1 /* Elimina */
DO:
   IF c-codigo-node = "" THEN
      RETURN.

   IF AVAIL ttBcLayout THEN DO:
      IF ttBcLayout.log-datasul = NO THEN DO:
         {utp/ut-table.i mgcld bc-layout-registro-item 1}
         RUN utp/ut-msgs.p("SHOW":U,
                           4350,
                           RETURN-VALUE).
         IF RETURN-VALUE = "NO":U THEN
            RETURN NO-APPLY.
      END.

      ASSIGN c-parent-node = DYNAMIC-FUNCTION('getNodeParentKey' IN h-4gltreeview, c-codigo-node).

      ASSIGN c-tag-node = DYNAMIC-FUNCTION('getNodeTag' IN h-4gltreeview, c-codigo-node).   

      RUN buscaNumLayout (INPUT ttBcLayout.cod-layout,
                          INPUT c-codigo-node,
                          OUTPUT iNumLayoutReg,
                          OUTPUT iNumSeqReg,
                          OUTPUT iNumSeqRegSeg). 

      /* Elimina Item Selecionado  */
      IF ttBcLayout.log-datasul = NO THEN DO:
         /* se n∆o tiver items na estrutura retorna */
         IF c-codigo-node = "" THEN
            RETURN.
         
         IF iNumSeqReg <> 0 THEN
           FOR FIRST ttRegEstr
              WHERE ttRegEstr.numItem = iNumSeqReg:
              RUN deleteNode IN h-4gltreeview("i":U + STRING(ttRegEstr.numLayoutRegistro) + "|":U + STRING(ttRegEstr.numItem),"") NO-ERROR.   
              DELETE ttRegEstr.
           END.
         ELSE
           FOR EACH ttRegEstr
              WHERE ttRegEstr.numLayoutRegistro = iNumLayoutReg:
              RUN deleteNode IN h-4gltreeview("p":U + STRING(ttRegEstr.numLayoutRegistro),"") NO-ERROR.   
              DELETE ttRegEstr.
           END.       

         RUN pi-atualizaTreeview IN THIS-PROCEDURE.
         
         RUN applyEntry IN h-4gltreeview(INPUT "").

         FIND FIRST ttRegEstr NO-ERROR.
         IF c-codigo-node BEGINS "p" THEN
            IF AVAIL ttRegEstr THEN DO:
               ASSIGN lOk = DYNAMIC-FUNCTION('selectNode' IN h-4gltreeview,"p":U + STRING(ttRegEstr.numLayoutRegistro)).
            END.
            ELSE
               ASSIGN c-codigo-node = "".
         
         IF c-codigo-node BEGINS "i" THEN
            ASSIGN lOk = DYNAMIC-FUNCTION('selectNode' IN h-4gltreeview,"i":U + STRING(iNumLayoutReg) + "|":U + STRING(iNumSeqReg + 10)).
         
         RUN controlButtons IN THIS-PROCEDURE (YES).  
      END.
      ELSE DO:
         /* Prepara objetos para consulta */
         IF iNumSeqReg <> 0 THEN
            FOR FIRST ttRegEstr
                WHERE ttRegEstr.numItem = iNumSeqReg:
                ASSIGN iTipoItem = ttRegEstr.TipoItem.
            END.
         ELSE
            ASSIGN iTipoItem = 0.

         /* Verifica se eh Constante, Linha ou Espaáo */
         IF iTipoItem = 2 OR iTipoItem = 3 OR iTipoItem = 4 THEN DO:
            FOR FIRST ttRegEstr
               WHERE ttRegEstr.numItem = iNumSeqReg:
               ASSIGN cConst = STRING(ttRegEstr.tipoItem)   + '|' +  /* Tipo  Item   */
                               STRING(ttRegEstr.valorItem)  + '|' +  /* Valor Item   */
                               STRING(ttRegEstr.posInicial) + '|' +  /* Pos Inicial  */
                               STRING(ttRegEstr.idInicial)  + '|' +  /* ID Inicial   */
                               STRING(ttRegEstr.idFinal)    + '|' +  /* ID Final     */
                               STRING(ttRegEstr.Detalhamento).       /* Detalhamento */ 
            END.                
            
            RUN bcp/bc0102d.w PERSISTENT SET h-bc0102d ( INPUT THIS-PROCEDURE,
                                                         INPUT 0,
                                                         INPUT "VIEW":U,
                                                         INPUT ttBcLayout.ind-leitura-campo, 
                                                         INPUT cConst).
            
            RUN dispatch IN h-bc0102d('initialize').                       
         END.
         ELSE DO:
            FOR FIRST ttRegEstr
               WHERE ttRegEstr.numLayoutRegistro = iNumLayoutReg
                 AND ttRegEstr.TipoItem          = 0:
                /* modificacao do item selecionado */
                ASSIGN cConst = STRING(ttRegEstr.tipoItem)      + '|':U + /* tipo-item    */
                                STRING(ttRegEstr.tipoDado)      + '|':U + /* tipo-dado    */
                                STRING(ttRegEstr.DesLabel)      + '|':U + /* valor-item   */
                                STRING(ttRegEstr.formato)       + '|':U + /* formato      */
                                STRING(ttRegEstr.posInicial)    + '|':U + /* pos-inicial  */
                                STRING(ttRegEstr.numDecimais)   + '|':U + /* num-decimais */
                                STRING(ttRegEstr.idInicial)     + '|':U + /* id-inicial   */
                                STRING(ttRegEstr.idFinal)       + '|':U + /* id-final     */
                                STRING(ttRegEstr.ValorCampo)    + '|':U + /* Valor-Campo  */
                                STRING(ttRegEstr.Detalhamento).           /* Detalhamento */
            END.
            IF iNumSeqReg <> 0 THEN
               FOR FIRST ttRegEstr
                  WHERE ttRegEstr.numItem = iNumSeqReg:
                  ASSIGN cConst = STRING(ttRegEstr.tipoItem)      + '|':U + /* tipo-item    */
                                  STRING(ttRegEstr.tipoDado)      + '|':U + /* tipo-dado    */
                                  STRING(ttRegEstr.DesLabel)      + '|':U + /* valor-item   */
                                  STRING(ttRegEstr.formato)       + '|':U + /* formato      */
                                  STRING(ttRegEstr.posInicial)    + '|':U + /* pos-inicial  */
                                  STRING(ttRegEstr.numDecimais)   + '|':U + /* num-decimais */
                                  STRING(ttRegEstr.idInicial)     + '|':U + /* id-inicial   */
                                  STRING(ttRegEstr.idFinal)       + '|':U + /* id-final     */
                                  STRING(ttRegEstr.ValorCampo)    + '|':U + /* Valor-Campo  */
                                  STRING(ttRegEstr.Detalhamento).           /* Detalhamento */                      
               END.

            RUN bcp/bc0102e.w PERSISTENT SET h-bc0102e ( INPUT THIS-PROCEDURE,
                                                         INPUT 0,
                                                         "UPDATE":U,
                                                         ttBcLayout.cod-tipo-layout,
                                                         ttBcLayout.ind-leitura-campo,
                                                         INPUT cConst).
            
            RUN dispatch IN h-bc0102e('initialize').
         END.
      END.
   END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btEspaco
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btEspaco wMasterDetail
ON CHOOSE OF btEspaco IN FRAME fPage1 /* Espaáo */
DO:
   ASSIGN iTipoItem = 4.
   RUN criaConstLinhaEspaco. /* tipoItem */
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage0
&Scoped-define SELF-NAME btExit
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btExit wMasterDetail
ON CHOOSE OF btExit IN FRAME fPage0 /* Exit */
OR CHOOSE OF MENU-ITEM miExit IN MENU mbMain DO:
   APPLY "CLOSE":U TO THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btFirst
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btFirst wMasterDetail
ON CHOOSE OF btFirst IN FRAME fPage0 /* First */
OR CHOOSE OF MENU-ITEM miFirst IN MENU mbMain DO:
   RUN getFirst IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btGoTo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btGoTo wMasterDetail
ON CHOOSE OF btGoTo IN FRAME fPage0 /* Go To */
OR CHOOSE OF MENU-ITEM miGoTo IN MENU mbMain DO:
   RUN goToRecord IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btHelp
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btHelp wMasterDetail
ON CHOOSE OF btHelp IN FRAME fPage0 /* Help */
OR CHOOSE OF MENU-ITEM miContents IN MENU mbMain DO:
   {include/ajuda.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btLast
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btLast wMasterDetail
ON CHOOSE OF btLast IN FRAME fPage0 /* Last */
OR CHOOSE OF MENU-ITEM miLast IN MENU mbMain DO:
   RUN getLast IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage1
&Scoped-define SELF-NAME btLinha
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btLinha wMasterDetail
ON CHOOSE OF btLinha IN FRAME fPage1 /* Linha */
DO:
   ASSIGN iTipoItem = 3.
   RUN criaConstLinhaEspaco. /* tipoItem */
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btModifica
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btModifica wMasterDetail
ON CHOOSE OF btModifica IN FRAME fPage1 /* Modifica */
DO:
   IF c-codigo-node = "" THEN
      RETURN.

   IF AVAIL ttBcLayout THEN DO:
      ASSIGN c-parent-node = DYNAMIC-FUNCTION('getNodeParentKey' IN h-4gltreeview, c-codigo-node).

      ASSIGN c-tag-node = DYNAMIC-FUNCTION('getNodeTag' IN h-4gltreeview, c-codigo-node). 
      
      RUN buscaNumLayout (INPUT ttBcLayout.cod-layout,
                          INPUT c-codigo-node,
                          OUTPUT iNumLayoutReg,
                          OUTPUT iNumSeqReg,
                          OUTPUT iNumSeqRegSeg). 
                          
      IF iNumSeqReg <> 0 THEN
         FOR FIRST ttRegEstr
             WHERE ttRegEstr.numItem = iNumSeqReg:
             ASSIGN iTipoItem = ttRegEstr.TipoItem.
         END.
      ELSE
         ASSIGN iTipoItem = 0.

      /* Verifica se eh Constante, Linha ou Espaáo */
      IF iTipoItem = 2 OR iTipoItem = 3 OR iTipoItem = 4 THEN DO:
         FOR FIRST ttRegEstr
             WHERE ttRegEstr.numItem = iNumSeqReg:
             ASSIGN cConst = STRING(ttRegEstr.tipoItem)   + '|' +  /* Tipo  Item   */
                             STRING(ttRegEstr.valorItem)  + '|' +  /* Valor Item   */
                             STRING(ttRegEstr.posInicial) + '|' +  /* Pos Inicial  */
                             STRING(ttRegEstr.idInicial)  + '|' +  /* ID Inicial   */
                             STRING(ttRegEstr.idFinal)    + '|' +  /* ID Final     */
                             STRING(ttRegEstr.Detalhamento).       /* Detalhamento */ 
         END.  

         /* Executa programa para modificar item selecionado */
         RUN bcp/bc0102d.w PERSISTENT SET h-bc0102d ( INPUT THIS-PROCEDURE,
                                                      INPUT 1,
                                                      INPUT "UPDATE":U,
                                                      INPUT ttBcLayout.ind-leitura-campo, 
                                                      INPUT cConst).
         
         RUN dispatch IN h-bc0102d('initialize').                       
      END.
      ELSE DO:    
         IF iTipoItem = 0 THEN
            FOR FIRST ttRegEstr
                WHERE ttRegEstr.numLayoutRegistro = iNumLayoutReg
                  AND ttRegEstr.TipoItem          = 0:
                RUN goToKey IN hDBOBcTpLayoutReg (ttBcLayout.cod-tipo-layout, ttRegEstr.codTipoLayoutRegistro).
                IF RETURN-VALUE = "OK":U THEN DO:
                    RUN getCharField IN hDBOBcTpLayoutReg ("descricao":U, OUTPUT cValorItem).
                END.
                /* modificacao do item selecionado */
                ASSIGN icodTipolayout = ttRegEstr.codTipoLayoutRegistro
                               cConst = STRING(ttRegEstr.tipoItem)      + '|':U + /* tipo-item    */
                                        STRING(ttRegEstr.tipoDado)      + '|':U + /* tipo-dado    */
                                        STRING(ttRegEstr.DesLabel)      + '|':U + /* valor-item   */
                                        STRING(ttRegEstr.formato)       + '|':U + /* formato      */
                                        STRING(ttRegEstr.posInicial)    + '|':U + /* pos-inicial  */
                                        STRING(ttRegEstr.numDecimais)   + '|':U + /* num-decimais */
                                        STRING(ttRegEstr.idInicial)     + '|':U + /* id-inicial   */
                                        STRING(ttRegEstr.idFinal)       + '|':U + /* id-final     */
                                        STRING(ttRegEstr.ValorCampo)    + '|':U + /* Valor-Campo  */
                                        STRING(ttRegEstr.Detalhamento).           /* Detalhamento */
            END.
         ELSE
            FOR FIRST ttRegEstr
               WHERE ttRegEstr.numItem = iNumSeqReg:
                RUN goToKey IN hDBOBcLayoutRegItem (ttRegEstr.numLayoutRegistro,ttRegEstr.sequencia).
                IF RETURN-VALUE = "OK":U THEN DO:
                   RUN getCharField IN hDBOBcLayoutRegItem ("valor-item":U, OUTPUT cValorItem).
                END.
                IF ttRegEstr.tipoItem = 1 THEN
                  ASSIGN cDesLabel = ttRegEstr.DesLabel.
                
                ASSIGN icodTipolayout = ttRegEstr.codTipoLayoutRegistro
                               cConst = STRING(ttRegEstr.tipoItem)      + '|':U + /* tipo-item    */
                                        STRING(ttRegEstr.tipoDado)      + '|':U + /* tipo-dado    */
                                        STRING(cValorItem)              + '|':U + /* valor-item   */
                                        STRING(ttRegEstr.formato)       + '|':U + /* formato      */
                                        STRING(ttRegEstr.posInicial)    + '|':U + /* pos-inicial  */
                                        STRING(ttRegEstr.numDecimais)   + '|':U + /* num-decimais */
                                        STRING(ttRegEstr.idInicial)     + '|':U + /* id-inicial   */
                                        STRING(ttRegEstr.idFinal)       + '|':U + /* id-final     */
                                        STRING(ttRegEstr.ValorCampo)    + '|':U + /* Valor-Campo  */
                                        STRING(ttRegEstr.Detalhamento).           /* Detalhamento */                        
            END.

         RUN bcp/bc0102e.w PERSISTENT SET h-bc0102e ( INPUT THIS-PROCEDURE,
                                                      INPUT 1,
                                                      INPUT "UPDATE":U,
                                                      INPUT ttBcLayout.cod-tipo-layout, 
                                                      INPUT ttBcLayout.ind-leitura-campo,
                                                      INPUT cConst).
         
         RUN dispatch IN h-bc0102e('initialize').                       
      END.
   END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage0
&Scoped-define SELF-NAME btNext
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btNext wMasterDetail
ON CHOOSE OF btNext IN FRAME fPage0 /* Next */
OR CHOOSE OF MENU-ITEM miNext IN MENU mbMain DO:
   RUN getNext IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btPrev
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btPrev wMasterDetail
ON CHOOSE OF btPrev IN FRAME fPage0 /* Prev */
OR CHOOSE OF MENU-ITEM miPrev IN MENU mbMain DO:
   RUN getPrev IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btQueryJoins
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btQueryJoins wMasterDetail
ON CHOOSE OF btQueryJoins IN FRAME fPage0 /* Query Joins */
OR CHOOSE OF MENU-ITEM miQueryJoins IN MENU mbMain DO:
   RUN showQueryJoins IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btReportsJoins
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btReportsJoins wMasterDetail
ON CHOOSE OF btReportsJoins IN FRAME fPage0 /* Reports Joins */
OR CHOOSE OF MENU-ITEM miReportsJoins IN MENU mbMain DO:
   RUN showReportsJoins IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btSave
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btSave wMasterDetail
ON CHOOSE OF btSave IN FRAME fPage0 /* Save */
OR CHOOSE OF MENU-ITEM miSave IN MENU mbMain DO:
   DEF VAR h-acomp            AS HANDLE     NO-UNDO.
   DEF VAR iSequencia         AS INTEGER    NO-UNDO.
   DEF VAR lBcLayoutUtilizado AS LOGICAL    NO-UNDO.
   DEF VAR iNumVersao         AS INTEGER    NO-UNDO.
   DEF VAR rRowidBcLayout     AS ROWID      NO-UNDO.
   DEF VAR c-codigo-node-aux  AS CHARACTER  NO-UNDO.
   
   ASSIGN iNumVersao         = ttBcLayout.num-versao
          c-codigo-node-aux  = c-codigo-node.

   /* Inicia api de acompanhamento de execuá∆o */
   SESSION:SET-WAIT-STATE("general":U).
   
   RUN utp/ut-acomp.p PERSISTENT SET h-acomp.
   
   {utp/ut-liter.i Salvando_Dados}
   RUN pi-inicializar IN h-acomp (TRIM(RETURN-VALUE)).
   
   {utp/ut-liter.i Verificando_Layout...}
   RUN pi-acompanhar IN h-acomp (TRIM(RETURN-VALUE)).

   /* Verifica se BcLayout eh utilizado por tipo-etiqueta / bc-trans-filho */
   RUN verificaUtilizacaoLayout IN {&hDBOParent} (ttBcLayout.cod-layout,
                                                  ttBcLayout.log-datasul,
                                                  ttBcLayout.num-versao,
                                                  OUTPUT lBcLayoutUtilizado).
   IF lBcLayoutUtilizado THEN DO:
      /* Pergunta ao usuario se deseja criar nova versao do Bc-Layout */
      RUN utp/ut-msgs.p("SHOW":U,
                        26149,
                        "":U).
      IF RETURN-VALUE = "NO":U THEN DO:
         {utp/ut-liter.i Criando_Nova_Vers∆o...}
         RUN pi-acompanhar IN h-acomp (TRIM(RETURN-VALUE)).
         RUN criaNovaVersaoBcLayout IN {&hDBOParent} (ttBcLayout.cod-layout,
                                                      ttBcLayout.log-datasul,
                                                      OUTPUT iNumVersao).
      END.
      ELSE DO:
         /* Confirma Alteracao Layout */
         RUN utp/ut-msgs.p("SHOW":U,
                           4458,
                           "":U).
         IF RETURN-VALUE = "NO":U THEN DO:
            RUN pi-finalizar IN h-acomp.
            RETURN NO-APPLY.
         END.
      END.
   END.

   RUN pi-desabilita-cancela IN h-acomp.

   {utp/ut-liter.i Analisando_Estrutura...}
   RUN pi-acompanhar IN h-acomp (TRIM(RETURN-VALUE)).


   /* Verifica se eh geracao de uma copia do Bc-layout */
   IF iNumVersao <> ttBcLayout.num-versao THEN DO:
      /* Zera os registros de layout */
      FOR EACH ttRegEstr:
         ASSIGN ttRegEstr.sequencia         = 0
                ttRegEstr.numLayoutRegistro = 0.
      END.
   END.

   {utp/ut-liter.i Salvando_Estrutura...}
   RUN pi-acompanhar IN h-acomp (TRIM(RETURN-VALUE)).

   /* Salva estrutura no banco de dados */
   RUN salvaEstrReg IN {&hDBOSon1} ({&ttParent}.cod-layout,
                                    {&ttParent}.log-datasul, 
                                    iNumVersao, 
                                    TABLE ttRegEstr).

   /* Verifica se eh geracao de uma copia do Bc-layout */
   IF iNumVersao <> ttBcLayout.num-versao THEN DO:
      {utp/ut-liter.i Atualizando_Nova_Vers∆o...}
      RUN pi-acompanhar IN h-acomp (TRIM(RETURN-VALUE)).

      /* Busca nova Versao criada para reposicionar */
      RUN goToKey IN {&hDBOParent} ({&ttParent}.cod-layout, 
                                    {&ttParent}.log-datasul,  
                                    iNumVersao).
      
      RUN getRowid IN {&hDBOParent} (OUTPUT rRowidBcLayout).

      /* Reposiciona registro com base em um rowid */
      RUN repositionRecord IN THIS-PROCEDURE (rRowidBcLayout).
   END.

   /* fim do acomponhamento */
   RUN pi-finalizar IN h-acomp.
   SESSION:SET-WAIT-STATE("":U).  
   
   RUN afterDisplayFields. 
   
   ASSIGN lOk = DYNAMIC-FUNCTION('selectNode' IN h-4gltreeview,c-codigo-node-aux).  
   
   RUN controlButtons IN THIS-PROCEDURE (NO).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btSearch
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btSearch wMasterDetail
ON CHOOSE OF btSearch IN FRAME fPage0 /* Search */
OR CHOOSE OF MENU-ITEM miSearch IN MENU mbMain DO:
   {method/zoomreposition.i &ProgramZoom="clzoom/z01cl023.w"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage1
&Scoped-define SELF-NAME btSegmento
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btSegmento wMasterDetail
ON CHOOSE OF btSegmento IN FRAME fPage1 /* Segmento */
DO:
   /* solicita item a ser incluido ao usuario */
   IF AVAIL ttBcLayout THEN DO:                  
      ASSIGN c-parent-node = DYNAMIC-FUNCTION('getNodeParentKey' IN h-4gltreeview, c-codigo-node).

      ASSIGN c-tag-node = DYNAMIC-FUNCTION('getNodeTag' IN h-4gltreeview, c-codigo-node).          

      RUN bcp/bc0102b.w PERSISTENT SET h-bc0102b ( INPUT THIS-PROCEDURE,
                                                   INPUT 2,
                                                   INPUT hDBOBcTpLayoutReg,
                                                   INPUT {&hDBOParent},
                                                   INPUT {&hDBOSon1},
                                                   INPUT ttBcLayout.cod-layout).                       
      
      RUN dispatch IN h-bc0102b('initialize').
   END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage0
&Scoped-define SELF-NAME btUpdate
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btUpdate wMasterDetail
ON CHOOSE OF btUpdate IN FRAME fPage0 /* Update */
OR CHOOSE OF MENU-ITEM miUpdate IN MENU mbMain DO:
   RUN updateRecord IN THIS-PROCEDURE (INPUT "bcp/bc0102a.w":U).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wMasterDetail 


/*--- L¢gica para inicializaá∆o do programam ---*/
{masterdetail/mainblock.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterDestroyInterface wMasterDetail 
PROCEDURE afterDestroyInterface :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
   IF VALID-HANDLE({&hDBOParent}) THEN
      RUN destroy IN {&hDBOParent}. 
   
   IF VALID-HANDLE({&hDBOSon1}) THEN
      RUN destroy IN {&hDBOSon1}.
   
   IF VALID-HANDLE(hDBOBcLayoutRegItem) THEN
      RUN destroy IN hDBOBcLayoutRegItem.
   
   IF VALID-HANDLE(hDBOBcTpLayout) THEN
      RUN destroy IN hDBOBcTpLayout.
   
   IF VALID-HANDLE(hDBOBcTpLayoutReg) THEN
      RUN destroy IN hDBOBcTpLayoutReg.
   
   IF VALID-HANDLE(hDBOBcTpLayoutTab) THEN
      RUN destroy IN hDBOBcTpLayoutTab.
   
   IF VALID-HANDLE(h-4gltreeview) THEN DO:
      RUN destroyObject IN h-4gltreeview.
      DELETE PROCEDURE h-4gltreeview NO-ERROR.
   END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterDisplayFields wMasterDetail 
PROCEDURE afterDisplayFields :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
   IF NOT VALID-HANDLE(h-4gltreeview) THEN DO:
      RUN utp/ut-4gltreeview.w PERSISTENT SET h-4gltreeview.
   
      RUN setParentFrame IN h-4gltreeview (INPUT FRAME fPage1:HANDLE).

      RUN initializeObject IN h-4gltreeview.
   
      SUBSCRIBE TO "tvNodeEvent" IN h-4gltreeview.

      RUN repositionObject IN h-4gltreeview (1.00, 1.00).

      RUN resizeObject IN h-4gltreeview (8.25, 84.00).
   END.
   IF AVAIL ttBcLayout THEN DO:
      {method/referencefields.i &HandleDBOLeave="hDBOBcTpLayout"
                                &KeyValue1="ttBcLayout.cod-tipo-layout"
                                &FieldName1="descricao"
                                &Variable1="cDesTipoLayout"}

      ASSIGN cIndLeituraCampo = {clinc/i01cl023.i 04 ttBcLayout.ind-leitura-campo}.
      ASSIGN cSeparadorLinhas = ttBcLayout.{&SeparadorLinhas} 
             cSeparadorCampos = ttBcLayout.separador-campos. 

      /* Habilita Separadores se indicador de Leitura eh do tipo Separador */
      ASSIGN cSeparadorLinhas:VISIBLE IN FRAME fPage0 = (ttBcLayout.ind-leitura-campo = 3)
             cSeparadorCampos:VISIBLE IN FRAME fPage0 = (ttBcLayout.ind-leitura-campo = 3).

      /* tratamento para Tree-View */
      SESSION:SET-WAIT-STATE("general":U).
      RUN obtemEstrutura IN {&hDBOSon1} (hDBOBcLayout,
                                         hDBOBcLayoutRegItem,
                                         hDBOBcTpLayoutReg,
                                         OUTPUT TABLE ttRegEstr).
                                         
      RUN emptyTree IN h-4gltreeview NO-ERROR.
                                         
      RUN mostraEstrutura.

      /* Verifica se o Layout em questao eh Padrao Datasul */ 
      IF ttBcLayout.log-datasul THEN DO:
         /* Desabilita bot‰es para n∆o permitir modificaá∆o */ 
         DISABLE btSegmento
                 btCampo
                 btConstante
                 btLinha 
                 btEspaco
                 btAuxiliar
                 btCampoLivre
                 btModifica
            WITH FRAME fPage1.
         
         DISABLE btUpdate
                 btDelete
            WITH FRAME fPage0.

         /* Altera Label para Consultar informaá‰es */
         {utp/ut-liter.i Detalhe * R}
         ASSIGN btElimina:LABEL IN FRAME fPage1 = RETURN-VALUE.
         ENABLE btElimina WITH FRAME fPage1.
      END.
      ELSE DO:
         /* habilita bot‰es para permitir interaá∆o do usu†rio */
         ENABLE btSegmento
                btCampo
                btConstante
                btLinha 
                btEspaco
                btAuxiliar
                btCampoLivre
                btModifica
                btElimina
            WITH FRAME fPage1.
         
         ENABLE btUpdate
                btDelete
            WITH FRAME fPage0.

         /* Altera Label para Eliminar Itens */
         {utp/ut-liter.i Elimina * R}
         ASSIGN btElimina:LABEL IN FRAME fPage1 = RETURN-VALUE.
      END.
      SESSION:SET-WAIT-STATE("":U).
   END.
   ELSE 
      ASSIGN cDesTipoLayout   = "":U
             cIndLeituraCampo = "":U
             cSeparadorLinhas = "":U
             cSeparadorCampos = "":U.

   IF AVAIL ttBcLayout THEN
      DISPLAY cSeparadorLinhas WHEN ttBcLayout.ind-leitura-campo = 3
              cSeparadorCampos WHEN ttBcLayout.ind-leitura-campo = 3
              cDesTipoLayout
              cIndLeituraCampo WITH FRAME fPage0.

   IF cDesTipoLayout = 'Controle Etiqueta':U THEN DO:
      DISABLE btConstante
              btLinha 
              btEspaco
              btAuxiliar
              btCampoLivre
         WITH FRAME fPage1.
   END.
   ELSE DO:
      ENABLE btConstante
             btLinha 
             btEspaco
             btAuxiliar
             btCampoLivre
         WITH FRAME fPage1.
   END.

   RUN pi-atualizaTreeview IN THIS-PROCEDURE.   
   
   RUN applyEntry IN h-4gltreeview(INPUT "").

   FIND FIRST ttRegEstr NO-ERROR.
   
   IF AVAIL ttRegEstr THEN
      ASSIGN lOk = DYNAMIC-FUNCTION('selectNode' IN h-4gltreeview,"p":U + STRING(ttRegEstr.numLayoutRegistro)).
   ELSE
      ASSIGN c-codigo-node = "".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterInitializeInterface wMasterDetail 
PROCEDURE afterInitializeInterface :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
   {utp/ut-liter.i Linhas}
   ASSIGN cSeparadorLinhas:LABEL IN FRAME fPage0 = RETURN-VALUE.

   {utp/ut-liter.i Campos}
   ASSIGN cSeparadorCampos:LABEL IN FRAME fPage0 = RETURN-VALUE.

   {utp/ut-field.i mgcld bc-layout cod-tipo-layout 1}
   ASSIGN cDesTipoLayout:LABEL IN FRAME fPage0 = RETURN-VALUE.

   {utp/ut-liter.i Tratamento_Campos MBC L}
   ASSIGN cIndLeituraCampo:LABEL IN FRAME fPage0 = RETURN-VALUE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE controlButtons wMasterDetail 
PROCEDURE controlButtons :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
   DEF INPUT PARAM phabEstr AS LOG NO-UNDO.

   IF phabEstr THEN DO:
      DISABLE btFirst
              btPrev
              btNext
              btLast
              btGoTo
              btSearch
              btAdd
              btCopy
              btUpdate
              btDelete 
              btQueryJoins
              btReportsJoins
              btExit
              btHelp
         WITH FRAME fPage0.

      ENABLE btCancel
             btSave
         WITH FRAME fPage0.
   END.
   ELSE DO:
      ENABLE btFirst
             btPrev
             btNext
             btLast
             btGoTo
             btSearch
             btAdd
             btCopy
             btUpdate
             btDelete 
             btQueryJoins
             btReportsJoins
             btExit
             btHelp
         WITH FRAME fPage0.

      DISABLE btCancel
              btSave
         WITH FRAME fPage0.
   END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE criaAuxiliarCampoLivre wMasterDetail 
PROCEDURE criaAuxiliarCampoLivre :
/*------------------------------------------------------------------------------
  Purpose: Indica o Tipo de Item - 5-Auxiliar 6-Campo Fixo     
  Parameters:  <none>
  Notes:     
------------------------------------------------------------------------------*/
   IF c-codigo-node = "" THEN
      RETURN.
   
   ASSIGN iNumAux = 0.

   IF AVAIL ttBcLayout THEN DO:
      IF iTipoItem = 5 THEN DO:
         FOR EACH ttRegEstr:
            IF ttRegEstr.TipoItem = 5 THEN
               ASSIGN iNumAux = iNumAux + 1.
         END.
         RUN retornaLabelTipoItem(  INPUT iTipoItem,
                                    OUTPUT cLiteral).
         
         ASSIGN iNumAux = iNumAux + 1.
         
         /* inclusao de uma nova constante */
         ASSIGN cConst = STRING(5)              + '|':U + /* tipo-item    */
                         "CHARACTER":U          + '|':U + /* tipo-dado    */
                         TRIM(cLiteral) + "-":U + 
                         STRING(iNumAux,"99":U) + '|':U + /* valor-item   */
                         "X(30)":U              + '|':U + /* formato      */
                         STRING(1)              + '|':U + /* pos-inicial  */
                         STRING(0)              + '|':U + /* num-decimais */
                         "":U                   + '|':U + /* id-inicial   */
                         "":U                   + '|':U + /* id-final     */
                         "":U                   + '|':U + /* Valor-Campo  */ 
                         "":U.                            /* Detalhamento */ 
      END.
      ELSE DO: 
         RUN retornaLabelTipoItem( INPUT iTipoItem,
                                   OUTPUT cLiteral).

         /* inclusao de uma nova constante */
         ASSIGN cConst = STRING(6)     + '|':U + /* tipo-item    */
                         "CHARACTER":U + '|':U + /* tipo-dado    */
                         "":U          + '|':U + /* valor-item   */
                         "X(30)":U     + '|':U + /* formato      */
                         STRING(1)     + '|':U + /* pos-inicial  */
                         STRING(0)     + '|':U + /* num-decimais */
                         "":U          + '|':U + /* id-inicial   */
                         "":U          + '|':U + /* id-final     */
                         "":U          + '|':U + /* Valor Campo  */  
                         "":U.                   /* Detalhamento */  
      END.
      
      RUN bcp/bc0102e.w PERSISTENT SET h-bc0102e ( INPUT THIS-PROCEDURE,
                                                   INPUT 3,
                                                   INPUT "UPDATE":U,
                                                   INPUT ttBcLayout.cod-tipo-layout,
                                                   INPUT ttBcLayout.ind-leitura-campo, 
                                                   INPUT cConst).

      RUN dispatch IN h-bc0102e('initialize').
   END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE criaConstLinhaEspaco wMasterDetail 
PROCEDURE criaConstLinhaEspaco :
/*------------------------------------------------------------------------------
  Purpose: Indica o Tipo de Item - 5-Auxiliar 6-Campo Fixo    
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
   IF c-codigo-node = "" THEN
     RETURN.

   IF AVAIL ttBcLayout THEN DO:      
      ASSIGN c-parent-node = DYNAMIC-FUNCTION('getNodeParentKey' IN h-4gltreeview, c-codigo-node).

      ASSIGN c-tag-node = DYNAMIC-FUNCTION('getNodeTag' IN h-4gltreeview, c-codigo-node).

      /* inclusao de uma novo Item */
      ASSIGN cConst = STRING(iTipoItem) + '|' +  /* Tipo  Item   */
                      "":U              + '|' +  /* Valor Item   */
                      STRING(0)         + '|' +  /* Pos Inicial  */
                      "":U              + '|' +  /* ID Inicial   */
                      "":U              + '|' +  /* ID Final     */ 
                      "":U.                      /* Detalhamento */ 

      RUN bcp/bc0102d.w PERSISTENT SET h-bc0102d ( INPUT THIS-PROCEDURE,
                                                   INPUT 4,
                                                   INPUT "UPDATE":U,
                                                   INPUT ttBcLayout.ind-leitura-campo,
                                                   INPUT cConst).
      
      RUN dispatch IN h-bc0102d('initialize').
   END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE criaTTRegEstr wMasterDetail 
PROCEDURE criaTTRegEstr :
/*------------------------------------------------------------------------------
  Purpose:    
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
   DEFINE INPUT PARAMETER        cDados AS CHARACTER NO-UNDO.
   DEFINE INPUT-OUTPUT PARAMETER iSeq   AS INTEGER   NO-UNDO.

   ASSIGN iSeq = iSeq + 1.
   CREATE ttRegEstr.
   ASSIGN ttRegEstr.numItem               = iSeq
          ttRegEstr.sequencia             = INTEGER(ENTRY(2,cDados,'|':U))
          ttRegEstr.numLayoutRegistro     = INTEGER(ENTRY(3,cDados,'|':U))
          ttRegEstr.codTipoLayoutRegistro = INTEGER(ENTRY(4,cDados,'|':U))
          ttRegEstr.indOcorrencia         = INTEGER(ENTRY(5,cDados,'|':U))
          ttRegEstr.tipoItem              = INTEGER(ENTRY(6,cDados,'|':U))
          ttRegEstr.valorItem             = ENTRY(7,cDados,'|':U)
          ttRegEstr.tipoDado              = ENTRY(8,cDados,'|':U)
          ttRegEstr.formato               = ENTRY(9,cDados,'|':U)
          ttRegEstr.posInicial            = INTEGER(ENTRY(10,cDados,'|':U))
          ttRegEstr.numDecimais           = INTEGER(ENTRY(11,cDados,'|':U))
          ttRegEstr.idInicial             = ENTRY(12,cDados,'|':U)
          ttRegEstr.idFinal               = ENTRY(13,cDados,'|':U)
          ttRegEstr.DesLabel              = ENTRY(14,cDados,'|':U)
          ttRegEstr.ValorCampo            = ENTRY(15,cDados,'|':U)
          ttRegEstr.Detalhamento          = ENTRY(16,cDados,'|':U).
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE goToRecord wMasterDetail 
PROCEDURE goToRecord :
/*------------------------------------------------------------------------------
  Purpose:     Exibe dialog de V† Para
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
   DEFINE BUTTON btGoToCancel AUTO-END-KEY 
        LABEL "&Cancelar" 
        SIZE 10 BY 1
        BGCOLOR 8.

   DEFINE BUTTON btGoToOK AUTO-GO 
        LABEL "&OK" 
        SIZE 10 BY 1
        BGCOLOR 8.

   DEFINE RECTANGLE rtGoToButton
        EDGE-PIXELS 2 GRAPHIC-EDGE  
        SIZE 58 BY 1.42
        BGCOLOR 7.

   DEFINE VARIABLE rGoTo AS ROWID NO-UNDO.

   DEFINE VARIABLE iCodLayout  LIKE {&ttParent}.Cod-Layout  NO-UNDO.
   DEFINE VARIABLE lLogDatasul LIKE {&ttParent}.Log-Datasul NO-UNDO.
   DEFINE VARIABLE iNumVersao  LIKE {&ttParent}.Num-Versao  NO-UNDO.

   DEFINE FRAME fGoToRecord
       iCodLayout        AT ROW 1.21 COL 17.72 COLON-ALIGNED
       lLogDatasul       AT ROW 2.21 COL 17.72 COLON-ALIGNED
       iNumVersao        AT ROW 3.21 COL 17.72 COLON-ALIGNED 
       btGoToOK          AT ROW 4.63 COL 2.14
       btGoToCancel      AT ROW 4.63 COL 13
       rtGoToButton      AT ROW 4.38 COL 1
       SPACE(0.28)
       WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER SIDE-LABELS NO-UNDERLINE 
            THREE-D SCROLLABLE TITLE "V† Para Layout" FONT 1
            DEFAULT-BUTTON btGoToOK CANCEL-BUTTON btGoToCancel.

   &IF "{&FNC_MULTI_IDIOMA}" = "Yes" &THEN
      {utp/ut-liter.i V†_Para_Layout *}
      ASSIGN FRAME fGoToRecord:title = RETURN-VALUE.
      RUN utp/ut-trfrrp.p (INPUT FRAME fGoToRecord:HANDLE).
   &ENDIF

   ON "CHOOSE":U OF btGoToOK IN FRAME fGoToRecord DO:
      ASSIGN iCodLayout lLogDatasul iNumVersao.

      /* Posiciona query, do DBO, atravÇs dos valores do °ndice £nico */
      RUN goToKey IN {&hDBOParent} (INPUT iCodLayout, INPUT lLogDatasul, INPUT iNumVersao).
      IF RETURN-VALUE = "NOK":U THEN DO:
         {utp/ut-liter.i "Layout" *}
         RUN utp/ut-msgs.p(INPUT "SHOW":U,
                           INPUT 2,
                           INPUT RETURN-VALUE).

         RETURN NO-APPLY.
      END.

      /* Retorna rowid do registro corrente do DBO */
      RUN getRowid IN {&hDBOParent} (OUTPUT rGoTo).

      /* Reposiciona registro com base em um rowid */
      RUN repositionRecord IN THIS-PROCEDURE (INPUT rGoTo).

      APPLY "GO":U TO FRAME fGoToRecord.
   END.

   ENABLE iCodLayout lLogDatasul iNumVersao btGoToOK btGoToCancel 
       WITH FRAME fGoToRecord. 

   WAIT-FOR "GO":U OF FRAME fGoToRecord.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE initializeDBOs wMasterDetail 
PROCEDURE initializeDBOs :
/*------------------------------------------------------------------------------
  Purpose:     Inicializa DBOs
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
   IF NOT VALID-HANDLE({&hDBOParent}) THEN DO:
      {btb/btb008za.i1 clbo/bocl023.p YES}
      {btb/btb008za.i2 clbo/bocl023.p '' {&hDBOParent}} 
   END.
   RUN setConstraintMain IN {&hDBOParent} NO-ERROR.
   RUN openQueryStatic IN {&hDBOParent} (INPUT "Main":U) NO-ERROR.

   IF NOT VALID-HANDLE({&hDBOSon1}) THEN DO:
      {btb/btb008za.i1 clbo/bocl024.p YES}
      {btb/btb008za.i2 clbo/bocl024.p '' {&hDBOSon1}}
   END.
   RUN openQueryStatic IN {&hDBOSon1} (INPUT "Main":U) NO-ERROR.

   IF NOT VALID-HANDLE(hDBOBcLayoutRegItem) THEN DO:
      {btb/btb008za.i1 clbo/bocl025.p YES}
      {btb/btb008za.i2 clbo/bocl025.p '' hDBOBcLayoutRegItem}
   END.
   RUN openQueryStatic IN hDBOBcLayoutRegItem (INPUT "Main":U) NO-ERROR.

   IF NOT VALID-HANDLE(hDBOBcTpLayout) THEN DO:
      {btb/btb008za.i1 clbo/bocl026.p YES}
      {btb/btb008za.i2 clbo/bocl026.p '' hDBOBcTpLayout}
   END.
   RUN openQueryStatic IN hDBOBcTpLayout (INPUT "Main":U) NO-ERROR.

   IF NOT VALID-HANDLE(hDBOBcTpLayoutReg) THEN DO:
      {btb/btb008za.i1 clbo/bocl027.p YES}
      {btb/btb008za.i2 clbo/bocl027.p '' hDBOBcTpLayoutReg}
   END.
   RUN openQueryStatic IN hDBOBcTpLayoutReg (INPUT "Main":U) NO-ERROR.

   IF NOT VALID-HANDLE(hDBOBcTpLayoutTab) THEN DO:
      {btb/btb008za.i1 clbo/bocl028.p YES}
      {btb/btb008za.i2 clbo/bocl028.p '' hDBOBcTpLayoutTab}
   END.
   RUN openQueryStatic IN hDBOBcTpLayoutTab (INPUT "Main":U) NO-ERROR.
   RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE montaComplemento wMasterDetail 
PROCEDURE montaComplemento :
/*------------------------------------------------------------------------------
  Purpose   :  Monta o Complemento que ser† inserido no TreeView para posterior
               gravaá∆o do bc-layout-registro-item
  Parameters:  
  Observacao:  o conteudo final do item do TreeView eh composto pelo 
               IDGerado + pComplemento
------------------------------------------------------------------------------*/
   DEF INPUT PARAM  sequencia              AS INTEGER    NO-UNDO.
   DEF INPUT PARAM  pNumLayoutRegistro     AS INTEGER    NO-UNDO.
   DEF INPUT PARAM  pCodTipoLayoutRegistro AS INTEGER    NO-UNDO.
   DEF INPUT PARAM  pIndOcorrencia         AS INTEGER    NO-UNDO.
   DEF INPUT PARAM  pTipoItem              AS INTEGER    NO-UNDO.
   DEF INPUT PARAM  pValorItem             AS CHARACTER  NO-UNDO.
   DEF INPUT PARAM  pTipoDado              AS CHARACTER  NO-UNDO. 
   DEF INPUT PARAM  pFormato               AS CHARACTER  NO-UNDO. 
   DEF INPUT PARAM  pPos-inicial           AS INTEGER    NO-UNDO.
   DEF INPUT PARAM  pNum-decimais          AS CHARACTER  NO-UNDO.
   DEF INPUT PARAM  pid-inicial            AS CHARACTER  NO-UNDO.
   DEF INPUT PARAM  pid-final              AS CHARACTER  NO-UNDO.
   DEF INPUT PARAM  pDesLabel              AS CHARACTER  NO-UNDO.
   DEF INPUT PARAM  pValorCampo            AS CHARACTER  NO-UNDO.
   DEF INPUT PARAM  pDetalhamento          AS CHARACTER  NO-UNDO.
   DEF OUTPUT PARAM pComplemento           AS CHARACTER  NO-UNDO.

   ASSIGN pComplemento = STRING(sequencia)              + '|':U
                       + STRING(pNumLayoutRegistro)     + '|':U
                       + STRING(pCodTipoLayoutRegistro) + '|':U 
                       + STRING(pIndOcorrencia)         + '|':U 
                       + STRING(pTipoItem)              + '|':U 
                       + pValorItem                     + '|':U 
                       + pTipoDado                      + '|':U 
                       + pFormato                       + '|':U 
                       + STRING(pPos-inicial)           + '|':U 
                       + pNum-decimais                  + '|':U 
                       + pid-inicial                    + '|':U 
                       + pid-final                      + '|':U
                       + pDesLabel                      + '|':U
                       + pValorCampo                    + '|':U
                       + pDetalhamento.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE mostraEstrutura wMasterDetail 
PROCEDURE mostraEstrutura :
/*------------------------------------------------------------------------------
  Purpose:     Mostra a estrutura Layout Registro, previamente carregada na 
               temp-table ttRegEstr no TreeView.
  Parameters:  Nenhum
------------------------------------------------------------------------------*/
   DEF VAR iNivel AS INTEGER NO-UNDO.

   /* Le a tt da estrutura por cod-info para garantir a sequencia --------------*/
   FOR EACH ttRegEstr BY ttRegEstr.numItem:
      ASSIGN iNivel = IF ttRegEstr.TipoItem = 0 THEN 0 ELSE 1.

      RUN montaComplemento (ttRegEstr.sequencia,
                            ttRegEstr.numLayoutRegistro,
                            ttRegEstr.codTipoLayoutRegistro,
                            ttRegEstr.indOcorrencia,
                            ttRegEstr.tipoItem,
                            ttRegEstr.ValorItem,
                            ttRegEstr.tipoDado,
                            ttRegEstr.formato,
                            ttRegEstr.posInicial,
                            ttRegEstr.numDecimais,
                            ttRegEstr.idInicial,
                            ttRegEstr.idFinal,
                            ttRegEstr.DesLabel,
                            ttRegEstr.ValorCampo,
                            ttRegEstr.Detalhamento,
                            OUTPUT cComplemento).

      /* determina se cria como n°vel 0 ou filho -----------------------------*/
      IF  ttRegEstr.TipoItem = 0 THEN DO:
         RUN pi-create-node IN THIS-PROCEDURE ( INPUT "p":U + STRING(ttRegEstr.numLayoutRegistro),
                                                INPUT "",
                                                INPUT STRING(ttRegEstr.DesLabel),
                                                INPUT "image/treeview/tvpics/fold.bmp",
                                                INPUT cExpClp + CHR(1) + cFgColor + CHR(1) + cFont).
      END.
      ELSE DO:  
         RUN pi-create-node IN THIS-PROCEDURE ( INPUT "i":U + STRING(ttRegEstr.numLayoutRegistro) + "|":U + STRING(ttRegEstr.numItem),
                                                INPUT "p":U + STRING(ttRegEstr.numLayoutRegistro),
                                                INPUT STRING(ttRegEstr.DesLabel),
                                                INPUT "image/treeview/tvpics/blankSheet.bmp",
                                                INPUT cExpClp + CHR(1) + cFgColor + CHR(1) + cFont) NO-ERROR.   
      END.
   END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueriesSon wMasterDetail 
PROCEDURE openQueriesSon :
/*------------------------------------------------------------------------------
  Purpose:     Atualiza browsers filhos
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/

   RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-popula-tt-estrut-tab wMasterDetail 
PROCEDURE pi-popula-tt-estrut-tab :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
   /* Variable */
   DEF VAR h-buffer        AS HANDLE        NO-UNDO.
   DEF VAR h-field         AS HANDLE        NO-UNDO.
   DEF VAR wh-query        AS WIDGET-HANDLE NO-UNDO.
   DEF VAR v-num-cont      AS INTEGER       NO-UNDO.
   DEF VAR p-row-tabela    AS ROWID         NO-UNDO.
   
   /* Buffer */
   CREATE BUFFER h-buffer FOR TABLE 'bc-etiqueta':U. 
   
   /* Query */
   CREATE QUERY wh-query.
   EMPTY TEMP-TABLE tt-estrut-tab.
   
   /* obtená∆o dos atributos da tabela bt-etiq */
   FIND FIRST tt-estrut-tab NO-ERROR.
   IF NOT AVAILABLE tt-estrut-tab THEN
      CREATE tt-estrut-tab.
   
   wh-query:SET-BUFFERS(h-buffer).                     
   wh-query:QUERY-PREPARE('FOR EACH bc-etiqueta NO-LOCK':U).
   wh-query:QUERY-OPEN().
   wh-query:GET-FIRST().
   ASSIGN H-BUFFER = wh-query:GET-BUFFER-HANDLE(1).
   REPEAT v-num-cont = 1 TO H-BUFFER:NUM-FIELDS:
       h-field = H-BUFFER:BUFFER-FIELD(v-num-cont).
       CREATE tt-estrut-tab.
       ASSIGN tt-estrut-tab.atributo   = h-field:NAME
              tt-estrut-tab.titulo     = h-field:LABEL
              tt-estrut-tab.titulo-col = h-field:COLUMN-LABEL.
   END.                  
   RETURN 'OK':U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE retornaDescricaoSegmento wMasterDetail 
PROCEDURE retornaDescricaoSegmento :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
   DEF INPUT PARAM  pCodTipoLayout         AS INTEGER   NO-UNDO.
   DEF INPUT PARAM  pCodTipoLayoutRegistro AS INTEGER   NO-UNDO.
   DEF OUTPUT PARAM pDescricao             AS CHARACTER NO-UNDO.
   
   RUN goToKey IN hDBOBcTpLayoutReg (pCodTipoLayout, pCodTipoLayoutRegistro).
   IF RETURN-VALUE = "OK":U THEN DO:
      RUN getCharField IN hDBOBcTpLayoutReg ("descricao":U,
                                             OUTPUT pDescricao).
   END.
   ELSE
      ASSIGN pDescricao = "":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE retornaLabelTipoItem wMasterDetail 
PROCEDURE retornaLabelTipoItem :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
   DEF INPUT  PARAM pTipoItem AS INT  NO-UNDO.
   DEF OUTPUT PARAM pretorno  AS CHAR NO-UNDO.

   CASE pTipoItem:
      WHEN 0 THEN DO:
         {utp/ut-liter.i Segmento * R}
      END.
      WHEN 1 THEN DO:
         {utp/ut-liter.i Campo * R}
      END.
      WHEN 2 THEN DO:
         {utp/ut-liter.i Constante * R}
      END.
      WHEN 3 THEN DO:
         {utp/ut-liter.i Nova_Linha * R}
      END.
      WHEN 4 THEN DO:
         {utp/ut-liter.i Espaáo * R}
      END.
      WHEN 5 THEN DO:
         {utp/ut-liter.i Auxiliar * R}
      END.
      WHEN 6 THEN DO:
         {utp/ut-liter.i Campo_Fixo * R}
      END.
      OTHERWISE DO:
         ASSIGN pRetorno = "":U.
         RETURN.
      END.
   END CASE.
   ASSIGN pRetorno = RETURN-VALUE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE selecionaCampo wMasterDetail 
PROCEDURE selecionaCampo :
/*------------------------------------------------------------------------------
  Purpose: Indica o Tipo de Item - 1-Campo 6-Campo Fixo     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/   
   IF c-codigo-node = "" THEN
      RETURN.

   IF AVAIL ttBcLayout THEN DO:
      ASSIGN c-parent-node = DYNAMIC-FUNCTION('getNodeParentKey' IN h-4gltreeview, c-codigo-node).

      ASSIGN c-tag-node = DYNAMIC-FUNCTION('getNodeTag' IN h-4gltreeview, c-codigo-node).

      RUN buscaRegistroLayout IN {&hDBOSon1} (INPUT ttBcLayout.cod-layout,
                                              INPUT c-codigo-node,
                                              OUTPUT iNumLayoutReg,
                                              OUTPUT iCodTpLayReg,
                                              OUTPUT iNumSeqReg).

      /* Seleciona itens para Inclusao de Atributos no Tree View */
      RUN bcp/bc0102c.w PERSISTENT SET h-bc0102c ( INPUT THIS-PROCEDURE,
                                                   INPUT 5,
                                                   INPUT hDBOBcTpLayoutReg,
                                                   INPUT hDBOBcTpLayoutTab,
                                                   INPUT ttBcLayout.Cod-Tipo-Layout,
                                                   INPUT iCodTpLayReg).

      RUN dispatch IN h-bc0102c('initialize').                     
   END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE criaNovottRegEstr wMasterDetail 
PROCEDURE criaNovottRegEstr :
/*------------------------------------------------------------------------------
  Purpose   :  Monta o Complemento que ser† inserido no TreeView para posterior
               gravaá∆o do bc-layout-registro-item
  Parameters:  
  Observacao:  o conteudo final do item do TreeView eh composto pelo 
               IDGerado + pComplemento
------------------------------------------------------------------------------*/
   DEF INPUT PARAM numItem                AS INTEGER    NO-UNDO.
   DEF INPUT PARAM sequencia              AS INTEGER    NO-UNDO.
   DEF INPUT PARAM pNumLayoutRegistro     AS INTEGER    NO-UNDO.
   DEF INPUT PARAM pCodTipoLayoutRegistro AS INTEGER    NO-UNDO.
   DEF INPUT PARAM pIndOcorrencia         AS INTEGER    NO-UNDO.
   DEF INPUT PARAM pTipoItem              AS INTEGER    NO-UNDO.
   DEF INPUT PARAM pValorItem             AS CHARACTER  NO-UNDO.
   DEF INPUT PARAM pTipoDado              AS CHARACTER  NO-UNDO. 
   DEF INPUT PARAM pFormato               AS CHARACTER  NO-UNDO. 
   DEF INPUT PARAM pPos-inicial           AS INTEGER    NO-UNDO.
   DEF INPUT PARAM pNum-decimais          AS CHARACTER  NO-UNDO.
   DEF INPUT PARAM pid-inicial            AS CHARACTER  NO-UNDO.
   DEF INPUT PARAM pid-final              AS CHARACTER  NO-UNDO.
   DEF INPUT PARAM pDesLabel              AS CHARACTER  NO-UNDO.
   DEF INPUT PARAM pValorCampo            AS CHARACTER  NO-UNDO.
   DEF INPUT PARAM pDetalhamento          AS CHARACTER  NO-UNDO.
   
   DEFINE VARIABLE  iSeq                  AS INTEGER   NO-UNDO.
 
   CREATE ttRegEstr-aux.
   ASSIGN ttRegEstr-aux.numItem               = numItem
          ttRegEstr-aux.sequencia             = sequencia
          ttRegEstr-aux.numLayoutRegistro     = pNumLayoutRegistro
          ttRegEstr-aux.codTipoLayoutRegistro = pCodTipoLayoutRegistro
          ttRegEstr-aux.indOcorrencia         = pIndOcorrencia 
          ttRegEstr-aux.tipoItem              = pTipoItem 
          ttRegEstr-aux.valorItem             = pValorItem 
          ttRegEstr-aux.tipoDado              = pTipoDado 
          ttRegEstr-aux.formato               = pFormato
          ttRegEstr-aux.posInicial            = pPos-inicial 
          ttRegEstr-aux.numDecimais           = DEC(pNum-decimais) 
          ttRegEstr-aux.idInicial             = pid-inicial
          ttRegEstr-aux.idFinal               = pid-final 
          ttRegEstr-aux.DesLabel              = pDesLabel 
          ttRegEstr-aux.ValorCampo            = pValorCampo
          ttRegEstr-aux.Detalhamento          = pDetalhamento.
                        
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE alterattRegEstr wMasterDetail 
PROCEDURE alterattRegEstr :
/*------------------------------------------------------------------------------
  Purpose   :  Monta o Complemento que ser† inserido no TreeView para posterior
               gravaá∆o do bc-layout-registro-item
  Parameters:  
  Observacao:  o conteudo final do item do TreeView eh composto pelo 
               IDGerado + pComplemento
------------------------------------------------------------------------------*/
   DEF INPUT PARAM numItem                AS INTEGER    NO-UNDO.
   DEF INPUT PARAM pTipoItem              AS INTEGER    NO-UNDO.
   DEF INPUT PARAM pValorItem             AS CHARACTER  NO-UNDO.
   DEF INPUT PARAM pTipoDado              AS CHARACTER  NO-UNDO. 
   DEF INPUT PARAM pFormato               AS CHARACTER  NO-UNDO. 
   DEF INPUT PARAM pPos-inicial           AS INTEGER    NO-UNDO.
   DEF INPUT PARAM pNum-decimais          AS CHARACTER  NO-UNDO.
   DEF INPUT PARAM pid-inicial            AS CHARACTER  NO-UNDO.
   DEF INPUT PARAM pid-final              AS CHARACTER  NO-UNDO.
   DEF INPUT PARAM pDesLabel              AS CHARACTER  NO-UNDO.
   DEF INPUT PARAM pValorCampo            AS CHARACTER  NO-UNDO.
   DEF INPUT PARAM pDetalhamento          AS CHARACTER  NO-UNDO.
                              
   FOR FIRST ttRegEstr
       WHERE ttRegEstr.numItem = numItem:
      ASSIGN ttRegEstr.tipoItem      = pTipoItem
             ttRegEstr.valorItem     = pValorItem 
             ttRegEstr.tipoDado      = pTipoDado
             ttRegEstr.formato       = pFormato 
             ttRegEstr.posInicial    = pPos-inicial
             ttRegEstr.numDecimais   = DECIMAL(pNum-decimais)
             ttRegEstr.idInicial     = pid-inicial
             ttRegEstr.idFinal       = pid-final 
             ttRegEstr.DesLabel      = pDesLabel
             ttRegEstr.ValorCampo    = pValorCampo
             ttRegEstr.Detalhamento  = pDetalhamento.  
   END.
   
                        
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ajustattRegEstr wMasterDetail 
PROCEDURE ajustattRegEstr :
/*------------------------------------------------------------------------------
  Purpose   :  Monta o Complemento que ser† inserido no TreeView para posterior
               gravaá∆o do bc-layout-registro-item
  Parameters:  
  Observacao:  o conteudo final do item do TreeView eh composto pelo 
               IDGerado + pComplemento
------------------------------------------------------------------------------*/
   DEF INPUT PARAM pNumItem AS INTEGER      NO-UNDO.
     
   FOR EACH ttRegEstr
         BY ttRegEstr-aux.numItem:
      FIND FIRST ttRegEstr-aux
           WHERE ttRegEstr-aux.numItem = ttRegEstr.numItem NO-ERROR.
      IF AVAIL ttRegEstr-aux THEN DO:
         ASSIGN pNumItem = pNumItem + 10.
         
         CREATE ttRegEstr-aux.
         ASSIGN ttRegEstr-aux.numItem               = pNumItem
                ttRegEstr-aux.sequencia             = ttRegEstr.sequencia
                ttRegEstr-aux.numLayoutRegistro     = ttRegEstr.numLayoutRegistro
                ttRegEstr-aux.codTipoLayoutRegistro = ttRegEstr.codTipoLayoutRegistro
                ttRegEstr-aux.indOcorrencia         = ttRegEstr.indOcorrencia
                ttRegEstr-aux.tipoItem              = ttRegEstr.tipoItem
                ttRegEstr-aux.valorItem             = ttRegEstr.valorItem
                ttRegEstr-aux.tipoDado              = ttRegEstr.tipoDado 
                ttRegEstr-aux.formato               = ttRegEstr.formato
                ttRegEstr-aux.posInicial            = ttRegEstr.posInicial 
                ttRegEstr-aux.numDecimais           = ttRegEstr.numDecimais
                ttRegEstr-aux.idInicial             = ttRegEstr.idInicial  
                ttRegEstr-aux.idFinal               = ttRegEstr.idFinal  
                ttRegEstr-aux.DesLabel              = ttRegEstr.DesLabel 
                ttRegEstr-aux.ValorCampo            = ttRegEstr.ValorCampo
                ttRegEstr-aux.Detalhamento          = ttRegEstr.Detalhamento.           
      END.
      ELSE DO:
         CREATE ttRegEstr-aux.
         ASSIGN ttRegEstr-aux.numItem               = ttRegEstr.numItem 
                ttRegEstr-aux.sequencia             = ttRegEstr.sequencia
                ttRegEstr-aux.numLayoutRegistro     = ttRegEstr.numLayoutRegistro
                ttRegEstr-aux.codTipoLayoutRegistro = ttRegEstr.codTipoLayoutRegistro
                ttRegEstr-aux.indOcorrencia         = ttRegEstr.indOcorrencia
                ttRegEstr-aux.tipoItem              = ttRegEstr.tipoItem
                ttRegEstr-aux.valorItem             = ttRegEstr.valorItem
                ttRegEstr-aux.tipoDado              = ttRegEstr.tipoDado 
                ttRegEstr-aux.formato               = ttRegEstr.formato
                ttRegEstr-aux.posInicial            = ttRegEstr.posInicial 
                ttRegEstr-aux.numDecimais           = ttRegEstr.numDecimais
                ttRegEstr-aux.idInicial             = ttRegEstr.idInicial  
                ttRegEstr-aux.idFinal               = ttRegEstr.idFinal  
                ttRegEstr-aux.DesLabel              = ttRegEstr.DesLabel 
                ttRegEstr-aux.ValorCampo            = ttRegEstr.ValorCampo
                ttRegEstr-aux.Detalhamento          = ttRegEstr.Detalhamento.              
      END.
   END.

   EMPTY TEMP-TABLE ttRegEstr.
   
   FOR EACH ttRegEstr-aux
         BY ttRegEstr-aux.numItem:             
      CREATE ttRegEstr.
      BUFFER-COPY ttRegEstr-aux TO ttRegEstr.
   END.
   
   EMPTY TEMP-TABLE ttRegEstr-aux.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE buscaNumLayout wMasterDetail 
PROCEDURE buscaNumLayout:
/*------------------------------------------------------------------------------
  Purpose   :
             
  Parameters:
  Observacao:
------------------------------------------------------------------------------*/    
   DEF INPUT PARAM  pCodLayout     AS INTEGER   NO-UNDO.
   DEF INPUT PARAM  pNode          AS CHARACTER NO-UNDO.
   DEF OUTPUT PARAM pNumLayoutReg  AS INTEGER   NO-UNDO.
   DEF OUTPUT PARAM pNumSeqReg     AS INTEGER   NO-UNDO.
   DEF OUTPUT PARAM pNumSeqRegSeg  AS INTEGER   NO-UNDO.
   
   DEFINE VARIABLE cNumLayoutReg AS CHAR NO-UNDO.
   
   IF INDEX(pNode, "|") > 0 THEN
      ASSIGN cNumLayoutReg = TRIM(ENTRY(1, ENTRY(1,pNode,'|'),':':U))
             pNumSeqReg    = INTEGER(TRIM(ENTRY(1, ENTRY(2,pNode,'|'),':':U))).
   ELSE
      ASSIGN cNumLayoutReg = pNode.  

   FOR EACH ttRegEstr NO-LOCK:
      IF "p":U + STRING(ttRegEstr.numLayoutRegistro) = cNumLayoutReg 
         OR "i":U + STRING(ttRegEstr.numLayoutRegistro) = cNumLayoutReg THEN 
         ASSIGN pNumLayoutReg = ttRegEstr.numLayoutRegistro.                
   END.   
   
   FOR FIRST ttRegEstr NO-LOCK:
      IF "p":U + STRING(ttRegEstr.numLayoutRegistro) = cNumLayoutReg THEN 
         ASSIGN pNumSeqRegSeg = ttRegEstr.numItem.                
   END.
   RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piAtualizaSegmento wMasterDetail
PROCEDURE piAtualizaSegmento :
/*------------------------------------------------------------------------------
  Notes: Atualiza registro
------------------------------------------------------------------------------*/
   DEFINE INPUT PARAM piTipoAcao        AS INTEGER   NO-UNDO.
   DEFINE INPUT PARAM piCodTpLayoutReg  AS INTEGER   NO-UNDO.
   DEFINE INPUT PARAM piIndOcorrencia   AS INTEGER   NO-UNDO.
   DEFINE INPUT PARAM pcDesLabel        AS CHARACTER NO-UNDO.
   
   ASSIGN iTipoAcao        = piTipoAcao
          iCodTpLayoutReg  = piCodTpLayoutReg  
          iIndOcorrencia   = piIndOcorrencia
          cDesLabel        = pcDesLabel.      
   
   RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piAtualizaSelecionaCampo wMasterDetail
PROCEDURE piAtualizaSelecionaCampo :
/*------------------------------------------------------------------------------
  Notes: Atualiza registro Seleciona Campo
------------------------------------------------------------------------------*/
   DEFINE INPUT PARAM piTipoAcao        AS INTEGER   NO-UNDO.
   DEFINE INPUT PARAM pcDesDtbaseTable  AS CHARACTER NO-UNDO.
   DEFINE INPUT PARAM pcDesField        AS CHARACTER NO-UNDO.
   
   ASSIGN iTipoAcao       = piTipoAcao
          cDesDtbaseTable = pcDesDtbaseTable  
          cDesField       = pcDesField.      
   
   RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piAtualizaConsLinEsp wMasterDetail
PROCEDURE piAtualizaConsLinEsp :
/*------------------------------------------------------------------------------
  Notes: Atualiza registro Constante, linha e Espaáo
------------------------------------------------------------------------------*/
   DEFINE INPUT PARAM piTipoAcao  AS INTEGER   NO-UNDO.
   DEFINE INPUT PARAM pcConst     AS CHARACTER NO-UNDO.
   
   ASSIGN iTipoAcao = piTipoAcao
          cConst    = pcConst.      
   
   RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piAtualizaReg wMasterDetail
PROCEDURE piAtualizaReg :
/*------------------------------------------------------------------------------
  Notes: Atualiza registro
------------------------------------------------------------------------------*/
   CASE iTipoAcao:
      WHEN 1 THEN DO:
         IF iTipoItem = 2 OR iTipoItem = 3 OR iTipoItem = 4 THEN DO:         
            IF cConst = "":U OR cConst = ? THEN
               RETURN NO-APPLY.
      
            /* Altera variavel cConst para utilizar mesma estrutura de ENTRYÔs */            
            ASSIGN cConst =   ENTRY(1,cConst,'|':U) + '|':U + /* tipo-item    */
                              "":U                  + '|':U + /* tipo-dado    */
                              ENTRY(2,cConst,'|':U) + '|':U + /* valor-item   */
                              "":U                  + '|':U + /* formato      */
                              ENTRY(3,cConst,'|':U) + '|':U + /* pos-inicial  */
                              "":U                  + '|':U + /* num-decimais */
                              ENTRY(4,cConst,'|':U) + '|':U + /* id-inicial   */
                              ENTRY(5,cConst,'|':U) + '|':U + /* id-final     */
                              "":U                  + '|':U + /* Valor-Campo  */
                              ENTRY(6,cConst,'|':U).          /* Detalhamento */
         END.
         IF cConst <> "":U AND cConst <> ? THEN DO:
            RUN retornaLabelTipoItem IN THIS-PROCEDURE ( iTipoItem,
                                                         OUTPUT cLiteral).
      
            /* Atualiza Label para Visualizaá∆o */
            CASE iTipoItem:
               WHEN 0 THEN DO:
                  IF c-codigo-node BEGINS "p" THEN DO:
                     /* Modifica Label - Altera o identificador */
                     ASSIGN cDesLabel = IF ENTRY(7,cConst,'|':U) <> "":U THEN ENTRY(7,cConst,'|':U) + " - ":U ELSE "":U.
      
                     ASSIGN cDesLabel = cValorItem + " (":U + TRIM(cLiteral) + ")":U.
                  END.  
               END.
               WHEN 2 OR WHEN 3 OR WHEN 4 OR WHEN 5 THEN DO:
                  ASSIGN cDesLabel = IF ENTRY(7,cConst,'|':U) <> "":U THEN ENTRY(7,cConst,'|':U) + " - ":U ELSE "":U.
                  IF ENTRY(3,cConst,'|':U) <> "":U THEN
                     ASSIGN cDesLabel = cDesLabel + ENTRY(3,cConst,'|':U).
                  
                  ASSIGN cDesLabel = cDesLabel + " (":U + TRIM(cLiteral) + ")":U.
               END.
               WHEN 6 THEN DO:
                  ASSIGN cDesLabel = IF ENTRY(7,cConst,'|':U) <> "":U THEN ENTRY(7,cConst,'|':U) + " - ":U ELSE "":U.
                  IF ENTRY(9,cConst,'|':U) <> "":U THEN
                     ASSIGN cDesLabel = cDesLabel + ENTRY(9,cConst,'|':U) + " - ":U .
      
                  IF ENTRY(3,cConst,'|':U) <> "":U THEN
                     ASSIGN cDesLabel = cDesLabel + ENTRY(3,cConst,'|':U).
                  
                  ASSIGN cDesLabel = cDesLabel + " (":U + TRIM(cLiteral) + ")":U .
               END.
            END CASE.
            
            RUN alterattRegEstr (IF iNumSeqReg = 0 THEN iNumSeqRegSeg ELSE iNumSeqReg,
                                 iTipoItem,                      /* tipo Item                   */
                                 ENTRY(3,cConst,'|':U),          /* valor item                  */
                                 ENTRY(2,cConst,'|':U),          /* tipo dado                   */
                                 ENTRY(4,cConst,'|':U),          /* formato                     */
                                 INTEGER(ENTRY(5,cConst,'|':U)), /* posicao inicial             */ 
                                 INTEGER(ENTRY(6,cConst,'|':U)), /* numero decimais             */
                                 ENTRY(7,cConst,'|':U),          /* id inicial                  */
                                 ENTRY(8,cConst,'|':U),          /* id Final                    */
                                 cDesLabel,                      /* Label para Visualizacao     */ 
                                 ENTRY(9,cConst,'|':U),          /* Valor Campo                 */
                                 ENTRY(10,cConst,'|':U)).        /* Detalhamento Item           */
                  
            RUN emptyTree IN h-4gltreeview NO-ERROR.
            
            RUN mostraEstrutura.
                                          
            RUN pi-atualizaTreeview IN THIS-PROCEDURE.   
      
            RUN applyEntry IN h-4gltreeview(INPUT "").
      
            ASSIGN lOk = DYNAMIC-FUNCTION('selectNode' IN h-4gltreeview,c-codigo-node).  
            /* Controle de botoes da tela */
            RUN controlButtons IN THIS-PROCEDURE (YES).
         END.
      END.
      WHEN 2 THEN DO:
         RUN buscaNumLayout (INPUT ttBcLayout.cod-layout,
                             INPUT c-codigo-node,
                             OUTPUT iNumLayoutReg,
                             OUTPUT iNumSeqReg,
                             OUTPUT iNumSeqRegSeg). 
   
         FOR LAST ttRegEstr
            WHERE ttRegEstr.numLayoutRegistro = iNumLayoutReg NO-LOCK:
            ASSIGN iNumItem = ttRegEstr.numItem + 10.
         END.
         
         /* Indica se o usuario selecionou um segmento valido */ 
         IF cDesLabel <> "":U AND cDesLabel <> ? THEN DO:
            RUN criaNovottRegEstr (iNumItem,              /* num item                   */
                                   0,                     /* sequencia                  */
                                   0,                     /* numero layout registro     */
                                   iCodTpLayoutReg,       /* bc-tipo-layout-registro    */
                                   iIndOcorrencia,        /* bc-tipo-layout-registro    */ 
                                   0,                     /* tipo Item ==> 0 - segmento */
                                   "",                    /* valor item                 */
                                   "",                    /* tipo dado                  */
                                   "",                    /* formato                    */
                                   0,                     /* posicao inicial            */ 
                                   0,                     /* numero decimais            */
                                   "",                    /* id inicial                 */
                                   "",                    /* id Final                   */
                                   cDesLabel,             /* Label para Visualizacao    */ 
                                   "",                    /* Valor Campo                */
                                   "").                   /* Detalhamento Item          */
                                   
            RUN ajustattRegEstr (iNumItem).
   
            RUN emptyTree IN h-4gltreeview NO-ERROR.
                                           
            RUN mostraEstrutura.
   
            RUN pi-atualizaTreeview IN THIS-PROCEDURE.   
      
            RUN applyEntry IN h-4gltreeview(INPUT "").
   
            /* Atualiza controle de Botoes da Tela */
            RUN controlButtons IN THIS-PROCEDURE (YES).
         END.
      END.
      WHEN 3 THEN DO:
         RUN buscaNumLayout (INPUT ttBcLayout.cod-layout,
                             INPUT c-codigo-node,
                             OUTPUT iNumLayoutReg,
                             OUTPUT iNumSeqReg,
                             OUTPUT iNumSeqRegSeg). 
                             
         IF iNumSeqReg = 0 THEN
            FOR LAST ttRegEstr
               WHERE ttRegEstr.numLayoutRegistro = iNumLayoutReg NO-LOCK:
               ASSIGN iNumItem = ttRegEstr.numItem + 10.
            END.
         ELSE
            ASSIGN iNumItem = iNumSeqReg + 10.   
   
         IF cConst <> "":U AND cConst <> ? THEN DO:
            /* Grava o Label para Visualizacao conforme TipoItem */
            IF iTipoItem = 6 THEN DO:
               /* Monta Label Para Visualizacao */
               ASSIGN cDesLabel = IF ENTRY(7,cConst,'|':U) <> "":U THEN ENTRY(7,cConst,'|':U) + " - " ELSE "":U.
               IF ENTRY(9,cConst,'|':U) <> "":U THEN
                  ASSIGN cDesLabel = cDesLabel  + ENTRY(9,cConst,'|':U) + " - ":U.
               
               IF ENTRY(3,cConst,'|':U) <> "":U THEN
                  ASSIGN cDesLabel = cDesLabel + ENTRY(3,cConst,'|':U).
               
               ASSIGN cDesLabel = cDesLabel + " (":U + TRIM(cLiteral) + ")":U.
            END.
            ELSE DO:
               ASSIGN cDesLabel = IF ENTRY(7,cConst,'|':U) <> "":U THEN ENTRY(7,cConst,'|':U) + " - " ELSE "":U.
               IF ENTRY(3,cConst,'|':U) <> "":U THEN
                  ASSIGN cDesLabel = cDesLabel + ENTRY(3,cConst,'|':U).
               
               ASSIGN cDesLabel = cDesLabel + " (":U + TRIM(cLiteral) + ")":U.
            END.
   
            RUN criaNovottRegEstr (iNumItem,
                                   0,                              /* sequencia                   */
                                   iNumLayoutReg,                  /* numero layout registro      */
                                   0,                              /* cod-tp-lay-reg              */
                                   0,                              /* ind-ocorrencia              */ 
                                   INTEGER(ENTRY(1,cConst,'|':U)), /* tipo Item                   */
                                   ENTRY(3,cConst,'|':U),          /* valor item                  */
                                   ENTRY(2,cConst,'|':U),          /* tipo dado                   */
                                   ENTRY(4,cConst,'|':U),          /* formato                     */
                                   INTEGER(ENTRY(5,cConst,'|':U)), /* posicao inicial             */ 
                                   INTEGER(ENTRY(6,cConst,'|':U)), /* numero decimais             */
                                   ENTRY(7,cConst,'|':U),          /* id inicial                  */
                                   ENTRY(8,cConst,'|':U),          /* id Final                    */
                                   cDesLabel,                      /* Label para Visualizacao     */ 
                                   ENTRY(9,cConst,'|':U),          /* Valor Campo                 */
                                   ENTRY(10,cConst,'|':U)).        /* Detalhamento Item           */
   
            RUN ajustattRegEstr (iNumItem).
   
            RUN emptyTree IN h-4gltreeview NO-ERROR.
                                           
            RUN mostraEstrutura.
   
            RUN pi-atualizaTreeview IN THIS-PROCEDURE.   
      
            RUN applyEntry IN h-4gltreeview(INPUT "").
   
            /* Controle de botoes da tela */
            RUN controlButtons IN THIS-PROCEDURE (YES).
         END.
      END.
      WHEN 4 THEN DO:
         RUN buscaNumLayout (INPUT ttBcLayout.cod-layout,
                             INPUT c-codigo-node,
                             OUTPUT iNumLayoutReg,
                             OUTPUT iNumSeqReg,
                             OUTPUT iNumSeqRegSeg). 
          
         IF iNumSeqReg = 0 THEN                   
            FOR LAST ttRegEstr
               WHERE ttRegEstr.numLayoutRegistro = iNumLayoutReg NO-LOCK:
                ASSIGN iNumItem = ttRegEstr.numItem.
            END.
         ELSE
            ASSIGN iNumItem = iNumSeqReg + 10.  
   
         IF cConst <> "":U AND cConst <> ? THEN DO:
            RUN retornaLabelTipoItem ( INPUT iTipoItem,
                                       OUTPUT cLiteral).
   
            /* Monta Label Para Visualizacao */
            ASSIGN cDesLabel = IF ENTRY(4,cConst,'|':U) <> "":U THEN ENTRY(4,cConst,'|':U) + " - " ELSE "":U.
            IF ENTRY(2,cConst,'|':U) <> "":U THEN
               ASSIGN cDesLabel = cDesLabel + ENTRY(2,cConst,'|':U).
            
            ASSIGN cDesLabel = cDesLabel + " (":U + TRIM(cLiteral) + ")":U.
   
            RUN criaNovottRegEstr (iNumItem,
                                   0,                          /* sequencia                   */
                                   iNumLayoutReg,              /* numero layout registro      */
                                   0,                          /* cod-tp-lay-reg              */
                                   0,                          /* ind-ocorrencia              */ 
                                   iTipoItem,                  /* tipo Item                   */
                                   ENTRY(2,cConst,'|':U),      /* valor item                  */
                                   "":U,                       /* tipo dado                   */
                                   "":U,                       /* formato                     */
                                   INT(ENTRY(3,cConst,'|':U)), /* posicao inicial             */ 
                                   0,                          /* numero decimais             */
                                   ENTRY(4,cConst,'|':U),      /* id inicial                  */
                                   ENTRY(5,cConst,'|':U),      /* id Final                    */
                                   cDesLabel,                  /* Label para Visualizacao     */ 
                                   "",                         /* Valor Campo                 */
                                   ENTRY(6,cConst,'|':U)).     /* Detalhamento Item           */
   
            RUN ajustattRegEstr (iNumItem).
   
            RUN emptyTree IN h-4gltreeview NO-ERROR.
                                           
            RUN mostraEstrutura.
   
            RUN pi-atualizaTreeview IN THIS-PROCEDURE.   
      
            RUN applyEntry IN h-4gltreeview(INPUT "").
   
            /* Controle de botoes da tela */
            RUN controlButtons IN THIS-PROCEDURE (YES).
         END.      
      END.
      WHEN 5 THEN DO:
         IF cDesField = ? THEN
            RETURN.
                            
         RUN buscaNumLayout (INPUT ttBcLayout.cod-layout,
                             INPUT c-codigo-node,
                             OUTPUT iNumLayoutReg,
                             OUTPUT iNumSeqReg,
                             OUTPUT iNumSeqRegSeg). 
         
         IF iNumSeqReg = 0 THEN
            FOR LAST ttRegEstr
               WHERE ttRegEstr.numLayoutRegistro = iNumLayoutReg NO-LOCK:
                ASSIGN iNumItem = ttRegEstr.numItem.
            END.
         ELSE
            ASSIGN iNumItem = iNumSeqReg.
   
         /* Criacao buffer dinamico */
         CREATE BUFFER hBuffer FOR TABLE cDesDtbaseTable NO-ERROR.
         IF NOT ERROR-STATUS:ERROR THEN DO:
            IF ttBcLayout.cod-tipo-layout = 3 THEN DO:
               RUN pi-popula-tt-estrut-tab.
            END.
            /* insere todos os atributos selecionados */
            bl_fields:
            DO iNumField = 1 TO NUM-ENTRIES(cDesField):
               /* decompoe o nome do atributo e o extent, caso exista */
               ASSIGN cFieldExtent = ENTRY(1,ENTRY(iNumField,cDesField   ),"(":U)
                      cField       = ENTRY(1,ENTRY(1        ,cFieldExtent),"[":U).
   
               REPEAT iCont = 1 TO hBuffer:NUM-FIELDS:
                  ASSIGN hField = hBuffer:BUFFER-FIELD(iCont).
                  IF hField:NAME = cField THEN DO:
                     ASSIGN c-inicial-aux = '' 
                            c-final-aux = ''.
                     IF  ttBcLayout.cod-tipo-layout = 3 THEN DO:
                         FIND tt-estrut-tab WHERE tt-estrut-tab.atributo = cField NO-ERROR.
                         IF AVAILABLE tt-estrut-tab THEN
                            ASSIGN c-inicial-aux = tt-estrut-tab.titulo 
                                   c-final-aux   = tt-estrut-tab.titulo-col.
                     END.
                     ASSIGN cValorItem = ENTRY(2,cDesDtbaseTable,".":U) + ".":U + cFieldExtent.
   
                     IF iTipoItem = 1 /* Campo */ THEN
                         ASSIGN cDesLabel  = cValorItem + " (":U + hField:LABEL + ")":U.
                     ELSE DO:
                         RUN retornaLabelTipoItem (iTipoItem, OUTPUT cLiteral).
                         ASSIGN cDesLabel  = cValorItem + " (":U + trim(cLiteral) + ")":U.
                     END.
                     
                     ASSIGN iNumItem = iNumItem + 10.
                     
                     RUN criaNovottRegEstr (iNumItem,
                                            0,               /* sequencia                  */
                                            iNumLayoutReg,   /* numero layout registro     */
                                            iCodTpLayReg,    /* cod-tp-lay-reg             */
                                            0,               /* ind-ocorrencia             */ 
                                            iTipoItem,       /* tipo Item                  */
                                            cValorItem,      /* valor item                 */
                                            hField:DATA-TYPE,/* tipo dado                  */
                                            hField:FORMAT,   /* formato                    */
                                            1,               /* posicao inicial            */ 
                                            0,               /* numero decimais Conversao  */
                                            c-inicial-aux,   /* id inicial                 */
                                            c-final-aux,      /* id finial                  */
                                            cDesLabel,       /* Label para Visualizacao    */ 
                                            "",              /* Valor Campo                */
                                            "").             /* Detalhamento Item          */
                                            
                     NEXT bl_fields.
                  END.
               END.
            END.
            
            RUN ajustattRegEstr (iNumItem).
            
            RUN emptyTree IN h-4gltreeview NO-ERROR.
                                           
            RUN mostraEstrutura.
   
            RUN pi-atualizaTreeview IN THIS-PROCEDURE.   
      
            RUN applyEntry IN h-4gltreeview(INPUT "").
            
            /* Controle de botoes da tela */
            RUN controlButtons IN THIS-PROCEDURE (YES).
            DELETE WIDGET hBuffer.
         END.
      END.
   END CASE.
   RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piBloqWindow wMasterDetail
PROCEDURE piBloqWindow :
/*------------------------------------------------------------------------------
  Notes: Bloqueia Tela
------------------------------------------------------------------------------*/
   {&WINDOW-NAME}:SENSITIVE = NO.
   
   RETURN "OK":U.
END PROCEDURE.
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piLibWindow wMasterDetail
PROCEDURE piLibWindow :
/*------------------------------------------------------------------------------
  Notes: Libera Tela
------------------------------------------------------------------------------*/
   {&WINDOW-NAME}:SENSITIVE = YES.
   
   RETURN "OK":U.
END PROCEDURE.
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
