&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          mgcex            PROGRESS
*/
&Scoped-define WINDOW-NAME wMasterDetail

/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE ttEmbarque NO-UNDO LIKE embarque-imp
       FIELD r-Rowid AS ROWID.
DEFINE TEMP-TABLE ttVeiculo NO-UNDO LIKE historico-embarque
       FIELD r-Rowid AS ROWID
       INDEX veiculo IS PRIMARY UNIQUE id-meio-transp.


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS wMasterDetail 
/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i IM0056 2.00.00.010 } /*** 010010 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i im0056 MIM}
&ENDIF

/********************************************************************************
** Copyright DATASUL S.A. (1999)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/

/* Temp-Table and Buffer definitions                                    */
{cxbo/bocx230d.i Veiculo}
{cxbo/bocx220.i ttBrowse}

CREATE WIDGET-POOL.

{include/i_dbvers.i} /*Include de Pr‚-Processadores*/

&IF '{&mgdis_version}' < '2.06f' &THEN
    /*Tecnica para implementar valida‡Æo produto Estendido*/
    {cdp/cdapi558.i &ProdutoEstendido=20 &ModuloEstendido=MIM}
&endif
/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program          IM0056
&GLOBAL-DEFINE Version        2.00.00.010
&GLOBAL-DEFINE DBOVersion       1.1

&GLOBAL-DEFINE Folder           YES
&GLOBAL-DEFINE InitialPage      1
&GLOBAL-DEFINE FolderLabels     Embarque

&GLOBAL-DEFINE First            YES
&GLOBAL-DEFINE Prev             YES
&GLOBAL-DEFINE Next             YES
&GLOBAL-DEFINE Last             YES
&GLOBAL-DEFINE GoTo             NO
&GLOBAL-DEFINE Search           YES

&GLOBAL-DEFINE AddParent        NO
&GLOBAL-DEFINE CopyParent       NO
&GLOBAL-DEFINE UpdateParent     NO
&GLOBAL-DEFINE DeleteParent     NO

&GLOBAL-DEFINE AddSon1          NO
&GLOBAL-DEFINE CopySon1         NO
&GLOBAL-DEFINE UpdateSon1       NO
&GLOBAL-DEFINE DeleteSon1       NO

&GLOBAL-DEFINE ttParent         ttVeiculo
&GLOBAL-DEFINE hDBOParent       hDBOVeiculo
&GLOBAL-DEFINE DBOParentTable   Veiculo

&GLOBAL-DEFINE ttSon1           ttEmbarque
&GLOBAL-DEFINE hDBOSon1         hDBOEmbarque
&GLOBAL-DEFINE DBOSon1Table     Embarque-imp

&GLOBAL-DEFINE page0Fields      ttVeiculo.id-meio-transp ~
                                ttVeiculo.cod-pto-contr ~
                                ttVeiculo.dt-previsao ~
                                ttVeiculo.dt-ult-previsao

&GLOBAL-DEFINE page1Browse      brSon1


/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */
DEFINE VARIABLE rGoToVeiculo    AS ROWID     NO-UNDO.
DEFINE VARIABLE rDetalhe        AS ROWID     NO-UNDO.
DEFINE VARIABLE rRowid          AS ROWID     NO-UNDO.
DEFINE VARIABLE iContador       AS INTEGER   NO-UNDO.
DEFINE VARIABLE cStatus         AS CHARACTER NO-UNDO.
DEFINE VARIABLE cMeioTranspAnt  AS CHARACTER NO-UNDO.
DEFINE VARIABLE cDescPtoContr   AS CHARACTER NO-UNDO.

/* Local Variable Definitions (DBOs Handles) ---                        */
DEFINE VARIABLE {&hDBOParent}   AS HANDLE    NO-UNDO.
DEFINE VARIABLE {&hDBOSon1}     AS HANDLE    NO-UNDO.
DEFINE VARIABLE h-bocx110       AS HANDLE    NO-UNDO.
DEFINE VARIABLE h-bocx230       AS HANDLE    NO-UNDO.
DEFINE VARIABLE h-bocx230a      AS HANDLE    NO-UNDO.
DEFINE VARIABLE h-ProgramDetail AS HANDLE    NO-UNDO.
DEFINE VARIABLE h-bocx2302       AS HANDLE    NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE MasterDetail
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fPage0
&Scoped-define BROWSE-NAME brSon1

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES ttEmbarque

/* Definitions for BROWSE brSon1                                        */
&Scoped-define FIELDS-IN-QUERY-brSon1 ttEmbarque.cod-estabel ~
ttEmbarque.embarque 
&Scoped-define ENABLED-FIELDS-IN-QUERY-brSon1 
&Scoped-define QUERY-STRING-brSon1 FOR EACH ttEmbarque NO-LOCK
&Scoped-define OPEN-QUERY-brSon1 OPEN QUERY brSon1 FOR EACH ttEmbarque NO-LOCK.
&Scoped-define TABLES-IN-QUERY-brSon1 ttEmbarque
&Scoped-define FIRST-TABLE-IN-QUERY-brSon1 ttEmbarque


/* Definitions for FRAME fPage1                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-fPage1 ~
    ~{&OPEN-QUERY-brSon1}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS ttVeiculo.id-meio-transp ~
ttVeiculo.cod-pto-contr ttVeiculo.dt-previsao ttVeiculo.dt-ult-previsao 
&Scoped-define ENABLED-TABLES ttVeiculo
&Scoped-define FIRST-ENABLED-TABLE ttVeiculo
&Scoped-Define ENABLED-OBJECTS btFirst btPrev btNext btLast btSearch ~
btQueryJoins btReportsJoins btExit btHelp btGoToVeiculo cDescPonto ~
dtEfetiva btSaveDtEfetiva RECT-11 rtParent rtToolBar 
&Scoped-Define DISPLAYED-FIELDS ttVeiculo.id-meio-transp ~
ttVeiculo.cod-pto-contr ttVeiculo.dt-previsao ttVeiculo.dt-ult-previsao 
&Scoped-define DISPLAYED-TABLES ttVeiculo
&Scoped-define FIRST-DISPLAYED-TABLE ttVeiculo
&Scoped-Define DISPLAYED-OBJECTS cDescPonto dtEfetiva 

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
       MENU-ITEM miLast         LABEL "&éltimo"        ACCELERATOR "CTRL-END"
       RULE
       MENU-ITEM miGoTo         LABEL "&V  Para"       ACCELERATOR "CTRL-T"
       MENU-ITEM miSearch       LABEL "&Pesquisa"      ACCELERATOR "CTRL-F5"
       RULE
       MENU-ITEM miAdd          LABEL "&Incluir"       ACCELERATOR "CTRL-INS"
       MENU-ITEM miCopy         LABEL "&Copiar"        ACCELERATOR "CTRL-C"
       MENU-ITEM miUpdate       LABEL "&Alterar"       ACCELERATOR "CTRL-A"
       MENU-ITEM miDelete       LABEL "&Eliminar"      ACCELERATOR "CTRL-DEL"
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


/* Definitions of the field level widgets                               */
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

DEFINE BUTTON btGoToVeiculo 
     IMAGE-UP FILE "image~\im-enter":U
     IMAGE-INSENSITIVE FILE "image~\ii-enter":U
     LABEL "Go" 
     SIZE 4 BY 1.17 TOOLTIP "V  Para".

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

DEFINE BUTTON btSaveDtEfetiva 
     IMAGE-UP FILE "image~\im-sav":U
     IMAGE-INSENSITIVE FILE "image~\ii-sav":U
     LABEL "Save" 
     SIZE 4 BY 1.17 TOOLTIP "Efetiva o Ponto de Controle".

DEFINE BUTTON btSearch 
     IMAGE-UP FILE "image~\im-sea":U
     IMAGE-INSENSITIVE FILE "image~\ii-sea":U
     LABEL "Search" 
     SIZE 4 BY 1.25.

DEFINE VARIABLE cDescPonto AS CHARACTER FORMAT "X(40)":U 
     VIEW-AS FILL-IN 
     SIZE 40 BY .88 NO-UNDO.

DEFINE VARIABLE dtEfetiva AS DATE FORMAT "99/99/9999":U 
     LABEL "Data Efetiva" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88 NO-UNDO.

DEFINE RECTANGLE RECT-11
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 90 BY 2.54.

DEFINE RECTANGLE rtParent
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 90 BY 1.5.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE  
     SIZE 90 BY 1.5
     BGCOLOR 7 .

DEFINE BUTTON btAcompanhamento 
     LABEL "Acompanhamento" 
     SIZE 14 BY 1 TOOLTIP "Acompanhamento individual do Embarque".

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY brSon1 FOR 
      ttEmbarque SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE brSon1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS brSon1 wMasterDetail _STRUCTURED
  QUERY brSon1 NO-LOCK DISPLAY
      ttEmbarque.cod-estabel format "x(05)":U
      ttEmbarque.embarque FORMAT "X(12)":U
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 82 BY 9.13
         FONT 2.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fPage0
     btFirst AT ROW 1.13 COL 1.57 HELP
          "Primeira ocorrˆncia"
     btPrev AT ROW 1.13 COL 5.57 HELP
          "Ocorrˆncia anterior"
     btNext AT ROW 1.13 COL 9.57 HELP
          "Pr¢xima ocorrˆncia"
     btLast AT ROW 1.13 COL 13.57 HELP
          "éltima ocorrˆncia"
     btSearch AT ROW 1.13 COL 17.57 HELP
          "Pesquisa"
     btQueryJoins AT ROW 1.13 COL 74.86 HELP
          "Consultas relacionadas"
     btReportsJoins AT ROW 1.13 COL 78.86 HELP
          "Relat¢rios relacionados"
     btExit AT ROW 1.13 COL 82.86 HELP
          "Sair"
     btHelp AT ROW 1.13 COL 86.86 HELP
          "Ajuda"
     ttVeiculo.id-meio-transp AT ROW 2.92 COL 21 COLON-ALIGNED
          LABEL "Ve¡culo de Transporte"
          VIEW-AS FILL-IN 
          SIZE 20 BY .88
     btGoToVeiculo AT ROW 2.83 COL 43.57 HELP
          "V  Para"
     ttVeiculo.cod-pto-contr AT ROW 4.58 COL 21 COLON-ALIGNED
          LABEL "Ponto de Controle a Efetivar"
          VIEW-AS FILL-IN 
          SIZE 6 BY .88
     cDescPonto AT ROW 4.58 COL 27.43 COLON-ALIGNED NO-LABEL
     ttVeiculo.dt-previsao AT ROW 5.63 COL 21 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 10 BY .88
     ttVeiculo.dt-ult-previsao AT ROW 5.63 COL 45 COLON-ALIGNED
          LABEL "éltima PrevisÆo"
          VIEW-AS FILL-IN 
          SIZE 10 BY .88
     dtEfetiva AT ROW 5.63 COL 69 COLON-ALIGNED
     btSaveDtEfetiva AT ROW 5.5 COL 81.43 HELP
          "Efetiva o Ponto de Controle"
     RECT-11 AT ROW 4.33 COL 1
     rtParent AT ROW 2.67 COL 1
     rtToolBar AT ROW 1 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 90 BY 18.71
         FONT 1.

DEFINE FRAME fPage1
     brSon1 AT ROW 1.17 COL 2
     btAcompanhamento AT ROW 10.33 COL 70 HELP
          "Acompanhamento individual do Embarque"
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.57 ROW 8.33
         SIZE 84.43 BY 10.75
         FONT 1.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: MasterDetail
   Allow: Basic,Browse,DB-Fields,Window,Query
   Add Fields to: Neither
   Temp-Tables and Buffers:
      TABLE: ttEmbarque T "?" NO-UNDO mgcex embarque-imp
      ADDITIONAL-FIELDS:
          FIELD r-Rowid AS ROWID
      END-FIELDS.
      TABLE: ttVeiculo T "?" NO-UNDO mgcex historico-embarque
      ADDITIONAL-FIELDS:
          FIELD r-Rowid AS ROWID
          INDEX veiculo IS PRIMARY UNIQUE id-meio-transp
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
         HEIGHT             = 18.79
         WIDTH              = 90
         MAX-HEIGHT         = 18.79
         MAX-WIDTH          = 90
         VIRTUAL-HEIGHT     = 18.79
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
   FRAME-NAME Custom                                                    */

DEFINE VARIABLE XXTABVALXX AS LOGICAL NO-UNDO.


ASSIGN XXTABVALXX = FRAME fPage1:MOVE-BEFORE-TAB-ITEM (btGoToVeiculo:HANDLE IN FRAME fPage0)
/* END-ASSIGN-TABS */.

/* SETTINGS FOR FILL-IN ttVeiculo.cod-pto-contr IN FRAME fPage0
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN ttVeiculo.dt-ult-previsao IN FRAME fPage0
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN ttVeiculo.id-meio-transp IN FRAME fPage0
   EXP-LABEL                                                            */
/* SETTINGS FOR FRAME fPage1
                                                                        */
/* BROWSE-TAB brSon1 1 fPage1 */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wMasterDetail)
THEN wMasterDetail:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE brSon1
/* Query rebuild information for BROWSE brSon1
     _TblList          = "Temp-Tables.ttEmbarque"
     _Options          = "NO-LOCK"
     _FldNameList[1]   = Temp-Tables.ttEmbarque.cod-estabel
     _FldNameList[2]   = Temp-Tables.ttEmbarque.embarque
     _Query            is OPENED
*/  /* BROWSE brSon1 */
&ANALYZE-RESUME

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
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
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


&Scoped-define FRAME-NAME fPage1
&Scoped-define SELF-NAME btAcompanhamento
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btAcompanhamento wMasterDetail
ON CHOOSE OF btAcompanhamento IN FRAME fPage1 /* Acompanhamento */
DO:
    /* Seta o cursor do mouse para espera */
    SESSION:SET-WAIT-STATE("GENERAL":U).
    IF  AVAIL ttEmbarque THEN DO:
        RUN findEmbarque IN h-bocx230a (INPUT  ttEmbarque.cod-estabel, 
                                        INPUT  ttEmbarque.embarque,
                                        OUTPUT cStatus).
        RUN getRowid     IN h-bocx230a (OUTPUT rDetalhe).

        RUN initializeDBOs   IN h-ProgramDetail.
        /* Reposiciona registro no programa detalhe com base em um rowid */
        RUN repositionRecord IN h-ProgramDetail (input rDetalhe).

        ASSIGN wMasterDetail:SENSITIVE = NO.
        RUN imp/im0055.w.
        ASSIGN wMasterDetail:SENSITIVE = YES.

        RUN refreshQuery IN THIS-PROCEDURE.
    END.
    /* Seta o cursor do mouse para normal */
    SESSION:SET-WAIT-STATE("":U).
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
OR  CHOOSE OF MENU-ITEM miFirst IN MENU mbMain DO:
    RUN refreshQuery IN THIS-PROCEDURE.
    RUN getFirst IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btGoToVeiculo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btGoToVeiculo wMasterDetail
ON CHOOSE OF btGoToVeiculo IN FRAME fPage0 /* Go */
DO:
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
OR  CHOOSE OF MENU-ITEM miLast IN MENU mbMain DO:
    RUN refreshQuery IN THIS-PROCEDURE.
    RUN getLast IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btNext
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btNext wMasterDetail
ON CHOOSE OF btNext IN FRAME fPage0 /* Next */
OR  CHOOSE OF MENU-ITEM miNext IN MENU mbMain DO:
    RUN refreshQuery IN THIS-PROCEDURE.
    RUN getNext IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btPrev
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btPrev wMasterDetail
ON CHOOSE OF btPrev IN FRAME fPage0 /* Prev */
OR  CHOOSE OF MENU-ITEM miPrev IN MENU mbMain DO:
    RUN refreshQuery IN THIS-PROCEDURE.
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


&Scoped-define SELF-NAME btSaveDtEfetiva
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btSaveDtEfetiva wMasterDetail
ON CHOOSE OF btSaveDtEfetiva IN FRAME fPage0 /* Save */
DO:
    /* Seta o cursor do mouse para espera */
    SESSION:SET-WAIT-STATE("GENERAL":U).
    IF  AVAIL ttEmbarque THEN DO:
        RUN serverSendRows IN hDBOEmbarque (input  1, input  ?, input  no, input  0,
                                            output iContador, 
                                            output table ttBrowse).
    
        IF  iContador > 0 THEN DO:
            RUN efetivaPontoControle IN h-bocx230 (input  dtEfetiva:screen-value in frame fPage0,
                                                   input  table ttBrowse,
                                                   output table RowErrors).

            IF  RETURN-VALUE = "NOK":U   OR
                CAN-FIND(FIRST RowErrors
                         WHERE RowErrors.ErrorSubType = "WARNING":U NO-LOCK) THEN DO:
                {method/showmessage.i1}
                {method/showmessage.i2 &Modal="YES"}
            END.
        END.
        ASSIGN dtEfetiva:screen-value in frame fPage0 = ?.
        RUN refreshQuery IN THIS-PROCEDURE.
    END.
    /* Seta o cursor do mouse para normal */
    SESSION:SET-WAIT-STATE("":U).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btSearch
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btSearch wMasterDetail
ON CHOOSE OF btSearch IN FRAME fPage0 /* Search */
OR CHOOSE OF MENU-ITEM miSearch IN MENU mbMain DO:
    {method/zoomreposition.i &ProgramZoom="cxzoom/z02cx230.w"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME ttVeiculo.cod-pto-contr
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ttVeiculo.cod-pto-contr wMasterDetail
ON LEAVE OF ttVeiculo.cod-pto-contr IN FRAME fPage0 /* Ponto de Controle a Efetivar */
DO: 
    RUN findCh-itiner IN h-bocx2302(INPUT ttVeiculo.cod-estabel,
                                    INPUT ttVeiculo.embarque,
                                    INPUT ttVeiculo.cod-itiner,
                                    INPUT INTEGER(ttVeiculo.cod-pto-contr:SCREEN-VALUE IN FRAME fPage0),
                                    OUTPUT cStatus).
    IF cStatus = "":U THEN DO:
        RUN getCharField IN h-bocx2302 (INPUT "descricao":U,
                                       OUTPUT cDescPtoContr).
        IF cDescPtoContr <> "":U THEN
            ASSIGN cDescPonto:SCREEN-VALUE IN FRAME fPage0 = cDescPtoContr.
    END.

    IF cDescPtoContr = "":U OR cStatus <> "":U THEN DO:
        {method/referencefields.i 
            &HandleDBOLeave="h-bocx110"
            &FindMethod="findCodigo"
            &KeyValue1="ttVeiculo.cod-pto-contr:SCREEN-VALUE IN FRAME fPage0"
            &FieldName1="descricao"
            &FieldScreen1="cDescPonto"
            &Frame1="fPage0"}
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME brSon1
&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wMasterDetail 


/*--- L¢gica para inicializa‡Æo do programam ---*/
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
    {method/showmessage.i3}

    IF  VALID-HANDLE({&hDBOParent}) THEN
        RUN destroy IN {&hDBOParent}.

    IF  VALID-HANDLE({&hDBOSon1}) THEN
        DELETE PROCEDURE {&hDBOSon1}.

    IF  VALID-HANDLE(h-bocx110) THEN
        DELETE PROCEDURE h-bocx110.

    IF  VALID-HANDLE(h-bocx230) THEN
        DELETE PROCEDURE h-bocx230.

    IF  VALID-HANDLE(h-bocx230a) THEN
        DELETE PROCEDURE h-bocx230a.

    IF  VALID-HANDLE(h-ProgramDetail) THEN
        DELETE PROCEDURE h-ProgramDetail.

    IF VALID-HANDLE(h-bocx2302) THEN DO:
        DELETE PROCEDURE h-bocx2302.
        ASSIGN h-bocx2302 = ?.
    END.

    RETURN "OK":U.
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

  APPLY "LEAVE":U TO ttVeiculo.cod-pto-contr IN FRAME fPage0.

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
    ENABLE ttVeiculo.id-meio-transp
           dtEfetiva
           btGoToVeiculo
           btSaveDtEfetiva
           with frame fPage0.

    ENABLE btAcompanhamento
           with frame fPage1.

    ASSIGN dtEfetiva:screen-value in frame fPage0 = ?.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE emptyFields wMasterDetail 
PROCEDURE emptyFields :
/*------------------------------------------------------------------------------
  Purpose:     Limpa os campos desabilitados da tela
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
    DISPLAY "" @ ttVeiculo.cod-pto-contr
            "" @ cDescPonto
            "" @ ttVeiculo.dt-previsao
            "" @ ttVeiculo.dt-ult-previsao
            with frame fPage0.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE emptyTTSon1 wMasterDetail 
PROCEDURE emptyTTSon1 :
/*------------------------------------------------------------------------------
  Purpose:     Esvazia temp-table do browse
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
    FOR EACH {&ttSon1}:
        DELETE {&ttSon1}.
    END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE goToRecord wMasterDetail 
PROCEDURE goToRecord :
/*------------------------------------------------------------------------------
  Purpose:     Posiciona no registro informado
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    ASSIGN cMeioTranspAnt = ttVeiculo.id-meio-transp:screen-value in frame fPage0.
    RUN closeQuery    IN {&hDBOParent} NO-ERROR.
    RUN loadTempTable IN {&hDBOParent} NO-ERROR.
    RUN openQueryStatic IN {&hDBOParent} (INPUT "Main":U) NO-ERROR. 

    /* Posiciona query, do DBO, atrav‚s dos valores do ¡ndice £nico */
    RUN goToVeiculo  IN {&hDBOParent} (INPUT  cMeioTranspAnt,
                                       OUTPUT rGoToVeiculo,
                                       OUTPUT TABLE RowErrors).
    IF  RETURN-VALUE = "NOK":U THEN DO:
        RUN emptyFields IN THIS-PROCEDURE.
        RUN emptyTTSon1 IN THIS-PROCEDURE.
        {&page1Browse}:REFRESH() in frame fPage1 NO-ERROR.
        {method/showmessage.i1}
        {method/showmessage.i2 &Modal="YES"}
    END.
    ELSE
        /* Reposiciona registro com base em um rowid */
        RUN repositionRecord IN THIS-PROCEDURE (INPUT rGoToVeiculo).

    RETURN "OK":U.
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

    /*--- Verifica se o DBO j  est  inicializado ---*/
    IF  NOT VALID-HANDLE({&hDBOParent}) OR
        {&hDBOParent}:TYPE <> "PROCEDURE":U OR
        {&hDBOParent}:FILE-NAME <> "cxbo/bocx230d.p":U THEN DO:
        {btb/btb008za.i1 cxbo/bocx230d.p YES}
        {btb/btb008za.i2 cxbo/bocx230d.p '' {&hDBOParent}}
    END.

    RUN loadTempTable IN {&hDBOParent} NO-ERROR.
    RUN openQueryStatic IN {&hDBOParent} (INPUT "Main":U) NO-ERROR.

    /*--- Verifica se o DBO j  est  inicializado ---*/
    IF  NOT VALID-HANDLE({&hDBOSon1}) OR 
        {&hDBOSon1}:TYPE <> "PROCEDURE":U OR
        {&hDBOSon1}:FILE-NAME <> "cxbo/bocx220.p":U THEN DO:
        {btb/btb008za.i1 cxbo/bocx220.p YES}
        {btb/btb008za.i2 cxbo/bocx220.p '' {&hDBOSon1}} 
    END.

    RUN cxbo/bocx110.p  persistent set h-bocx110.
    RUN cxbo/bocx230.p  persistent set h-bocx230.
    RUN cxbo/bocx230a.p persistent set h-bocx230a.
    RUN imp/im0055.w    persistent set h-ProgramDetail.
    
    IF NOT VALID-HANDLE(h-bocx2302) THEN
        RUN cxbo/bocx230.p PERSISTENT SET h-bocx2302.

    &IF '{&mgdis_version}' < '2.06f' &THEN
        /*Tecnica para implementar valida‡Æo produto Estendido*/
        {cdp/cdapi558.i1}
    &endif
    RETURN "OK":U.
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

    {masterdetail/openqueriesson.i &Parent="Veiculo"
                                   &Query="Son"
                                   &PageNumber="1"
                                   &QueryConstraint="7"
                                   &ConstraintParameters="ttVeiculo.id-meio-transp"}
    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE refreshQuery wMasterDetail 
PROCEDURE refreshQuery :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    ASSIGN cMeioTranspAnt = ttVeiculo.id-meio-transp:screen-value in frame fPage0.
    RUN closeQuery    IN {&hDBOParent} NO-ERROR.
    RUN loadTempTable IN {&hDBOParent} NO-ERROR.
    RUN openQueryStatic IN {&hDBOParent} (INPUT "Main":U) NO-ERROR. 

    RUN goToVeiculo  IN {&hDBOParent} (INPUT  cMeioTranspAnt,
                                       OUTPUT rRowid,
                                       OUTPUT TABLE RowErrors).
    IF  return-value = "NOK" then do: 
        RUN getRowid IN {&hDBOParent} (OUTPUT rRowid).
        IF  return-value = "NOK" then do:
            RUN getNext IN {&hDBOParent}.
            IF  return-value = "NOK" then
                RUN getPrev IN {&hDBOParent}.
            RUN getRowid IN {&hDBOParent} (OUTPUT rRowid).
        END.
    END.
    RUN repositionRecord IN THIS-PROCEDURE (INPUT rRowid).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

