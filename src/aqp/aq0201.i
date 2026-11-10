&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
*/
&Scoped-define WINDOW-NAME wMaintenance
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS wMaintenance 
/*:T*******************************************************************************
** Copyright TOTVS S.A. (2009)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da TOTVS, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i AQ0201 2.00.00.007 } /*** "010007" ***/

/* Chamada a include do gerenciador de licen‡as. Necessario alterar os parametros */
/*                                                                                */
/* <programa>:  Informar qual o nome do programa.                                 */
/* <m¢dulo>:  Informar qual o m¢dulo a qual o programa pertence.                  */

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i {1} MAQ}
&ENDIF

CREATE WIDGET-POOL.

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program        {1}
&GLOBAL-DEFINE Version        2.00.00.007

&GLOBAL-DEFINE Folder         NO
&GLOBAL-DEFINE InitialPage    1

&GLOBAL-DEFINE FolderLabels   

&GLOBAL-DEFINE First          NO
&GLOBAL-DEFINE Prev           NO
&GLOBAL-DEFINE Next           NO
&GLOBAL-DEFINE Last           NO
&GLOBAL-DEFINE GoTo           NO
&GLOBAL-DEFINE Search         NO

&GLOBAL-DEFINE Add            NO
&GLOBAL-DEFINE Copy           NO
&GLOBAL-DEFINE Update         NO
&GLOBAL-DEFINE Delete         NO
&GLOBAL-DEFINE Undo           NO
&GLOBAL-DEFINE Cancel         NO
&GLOBAL-DEFINE Save           NO

&GLOBAL-DEFINE ttTable        tt-regra-form-preco-custom
&GLOBAL-DEFINE hDBOTable      h-boin00972
&GLOBAL-DEFINE DBOTable       regra-form-preco

&GLOBAL-DEFINE page0KeyFields fi_key
&GLOBAL-DEFINE page0Fields    fi_key
&GLOBAL-DEFINE page0Widgets   btEliminar btCopia btSelecao btQueryJoins btReportsJoins btAddSon


/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

/* Local Variable Definitions (DBOs Handles) --- */
DEFINE VARIABLE {&hDBOTable} AS HANDLE NO-UNDO.
DEFINE VARIABLE h-boin172    AS HANDLE NO-UNDO.

DEFINE VARIABLE h-aqapi001   AS HANDLE NO-UNDO.

DEFINE VARIABLE cColumnLabel AS CHARACTER EXTENT 2 NO-UNDO.
DEFINE VARIABLE l-consulta   AS LOGICAL NO-UNDO.

{aqp/aqapi001.i} /* temp-tables */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Maintenance
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fpage0
&Scoped-define BROWSE-NAME brSon1

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES tt-regra-form-preco

/* Definitions for BROWSE brSon1                                        */
&Scoped-define FIELDS-IN-QUERY-brSon1 tt-regra-form-preco.dat-inic tt-regra-form-preco.dat-fim tt-regra-form-preco.cod-regra tt-regra-form-preco.cdn-seq fnDescTipo(tt-regra-form-preco.cdn-tipo) tt-regra-form-preco.val-unit tt-regra-form-preco.val-faixa-inic tt-regra-form-preco.val-faixa-fim fnDescAbrangen(tt-regra-form-preco.cdn-abrangen) fnFormataColunaChar('cod-pto-coleta', tt-regra-form-preco.cdn-abrangen, tt-regra-form-preco.cod-pto-coleta)FORMAT "x(12)":U fnFormataColunaChar('cod-propried', tt-regra-form-preco.cdn-abrangen, tt-regra-form-preco.cod-propried)FORMAT "x(16)":U fnFormataColunaInt('cdn-produt-rural', tt-regra-form-preco.cdn-abrangen, tt-regra-form-preco.cdn-produt-rural)FORMAT "x(12)":U fnFormataColunaInt('cdn-grp-produt', tt-regra-form-preco.cdn-abrangen, tt-regra-form-preco.cdn-grp-produt) fnFormataColunaChar('cod-rota', tt-regra-form-preco.cdn-abrangen, tt-regra-form-preco.cod-rota) fnFormataColunaChar('cod-regiao', tt-regra-form-preco.cdn-abrangen, tt-regra-form-preco.cod-regiao) fnFormataColunaChar('cod-estabel', tt-regra-form-preco.cdn-abrangen, tt-regra-form-preco.cod-estabel) tt-regra-form-preco.cod-exame tt-regra-form-preco.cod-comp fnDescAplicacao(tt-regra-form-preco.cdn-aplic) tt-regra-form-preco.cod-usuar-criac tt-regra-form-preco.dat-criac tt-regra-form-preco.cod-usuar-alter tt-regra-form-preco.dat-alter tt-regra-form-preco.descricao tt-regra-form-preco.it-codigo fnDescItem(tt-regra-form-preco.it-codigo) tt-regra-form-preco.des-narrat   
&Scoped-define ENABLED-FIELDS-IN-QUERY-brSon1   
&Scoped-define SELF-NAME brSon1
&Scoped-define QUERY-STRING-brSon1 FOR EACH tt-regra-form-preco NO-LOCK     BY tt-regra-form-preco.cdn-tipo     BY tt-regra-form-preco.dat-inic     BY tt-regra-form-preco.cod-regra     BY tt-regra-form-preco.cdn-seq     BY tt-regra-form-preco.cdn-abrangen     BY tt-regra-form-preco.cod-pto-coleta     BY tt-regra-form-preco.cod-propried     BY tt-regra-form-preco.cdn-produt-rural     BY tt-regra-form-preco.cdn-grp-produt     BY tt-regra-form-preco.cod-rota     BY tt-regra-form-preco.cod-regiao     BY tt-regra-form-preco.cod-estabel
&Scoped-define OPEN-QUERY-brSon1 OPEN QUERY {&SELF-NAME} FOR EACH tt-regra-form-preco NO-LOCK     BY tt-regra-form-preco.cdn-tipo     BY tt-regra-form-preco.dat-inic     BY tt-regra-form-preco.cod-regra     BY tt-regra-form-preco.cdn-seq     BY tt-regra-form-preco.cdn-abrangen     BY tt-regra-form-preco.cod-pto-coleta     BY tt-regra-form-preco.cod-propried     BY tt-regra-form-preco.cdn-produt-rural     BY tt-regra-form-preco.cdn-grp-produt     BY tt-regra-form-preco.cod-rota     BY tt-regra-form-preco.cod-regiao     BY tt-regra-form-preco.cod-estabel.
&Scoped-define TABLES-IN-QUERY-brSon1 tt-regra-form-preco
&Scoped-define FIRST-TABLE-IN-QUERY-brSon1 tt-regra-form-preco


/* Definitions for FRAME fpage0                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-fpage0 ~
    ~{&OPEN-QUERY-brSon1}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS rtToolBar btSelecao btCopia btQueryJoins ~
btReportsJoins btExit btHelp brSon1 btIncluir btModificar btEliminar 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnDescAbrangen wMaintenance 
FUNCTION fnDescAbrangen RETURNS CHARACTER
  ( iCdnAbrangen AS INTEGER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnDescAplicacao wMaintenance 
FUNCTION fnDescAplicacao RETURNS CHARACTER
  ( iCdnAplic AS INTEGER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnDescItem wMaintenance 
FUNCTION fnDescItem RETURNS CHARACTER
  ( cItCodigo AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnDescTipo wMaintenance 
FUNCTION fnDescTipo RETURNS CHARACTER
  ( iCdnTipo AS INTEGER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnFormataColunaChar wMaintenance 
FUNCTION fnFormataColunaChar RETURNS CHARACTER
  ( cCampo AS CHARACTER, iCdnAbrangen AS INTEGER, cValor AS CHARACTER)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnFormataColunaInt wMaintenance 
FUNCTION fnFormataColunaInt RETURNS CHARACTER
  ( cCampo AS CHARACTER, iCdnAbrangen AS INTEGER, iValor AS INT)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnVigencia wMaintenance 
FUNCTION fnVigencia RETURNS DATE
  ( i AS INTEGER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR wMaintenance AS WIDGET-HANDLE NO-UNDO.

/* Menu Definitions                                                     */
DEFINE SUB-MENU smFile 
       MENU-ITEM miSelec        LABEL "&Sele‡Æo"       ACCELERATOR "CTRL-S"
       MENU-ITEM miCopiar       LABEL "&Copiar"        ACCELERATOR "CTRL-C"
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
DEFINE BUTTON btCopia 
     IMAGE-UP FILE "image/im-autom.bmp":U
     IMAGE-INSENSITIVE FILE "image/ii-autom.bmp":U
     LABEL "":L 
     SIZE 4 BY 1.25 TOOLTIP "Copiar / Reajustar Regras".

DEFINE BUTTON btEliminar 
     LABEL "&Eliminar" 
     SIZE 10 BY 1.13 TOOLTIP "Eliminar".

DEFINE BUTTON btExit 
     IMAGE-UP FILE "image/im-exi":U
     IMAGE-INSENSITIVE FILE "image/ii-exi":U
     LABEL "Exit" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE BUTTON btHelp 
     IMAGE-UP FILE "image/im-hel":U
     IMAGE-INSENSITIVE FILE "image/ii-hel":U
     LABEL "Help" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE BUTTON btIncluir 
     LABEL "&Incluir" 
     SIZE 10 BY 1.13 TOOLTIP "Incluir".

DEFINE BUTTON btModificar 
     LABEL "&Modificar" 
     SIZE 10 BY 1.13 TOOLTIP "Modificar".

DEFINE BUTTON btQueryJoins 
     IMAGE-UP FILE "image/im-joi":U
     IMAGE-INSENSITIVE FILE "image/ii-joi":U
     LABEL "Query Joins" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE BUTTON btReportsJoins 
     IMAGE-UP FILE "image/im-pri":U
     IMAGE-INSENSITIVE FILE "image/ii-pri":U
     LABEL "Reports Joins" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE BUTTON btSelecao 
     IMAGE-UP FILE "image/im-ran.bmp":U
     IMAGE-INSENSITIVE FILE "image/ii-ran.bmp":U
     LABEL "":L 
     SIZE 4 BY 1.25 TOOLTIP "Sele‡Æo".

DEFINE VARIABLE fi_key AS CHARACTER FORMAT "X(256)":U 
      VIEW-AS TEXT 
     SIZE 2 BY .67 NO-UNDO.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 113 BY 1.5
     BGCOLOR 7 .

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY brSon1 FOR 
      tt-regra-form-preco SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE brSon1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS brSon1 wMaintenance _FREEFORM
  QUERY brSon1 NO-LOCK DISPLAY
      tt-regra-form-preco.dat-inic FORMAT "99/99/9999":U
      tt-regra-form-preco.dat-fim FORMAT "99/99/9999":U
      tt-regra-form-preco.cod-regra FORMAT "X(20)":U WIDTH 8
      tt-regra-form-preco.cdn-seq FORMAT ">>>,>>9":U COLUMN-LABEL 'Seq'  WIDTH 5
      fnDescTipo(tt-regra-form-preco.cdn-tipo) FORMAT "x(20)" COLUMN-LABEL 'Tipo' WIDTH 12
      tt-regra-form-preco.val-unit FORMAT "->>,>>>,>>9.9999":U COLUMN-LABEL 'Valor' WIDTH 8
      tt-regra-form-preco.val-faixa-inic FORMAT "->,>>>,>>9.9999":U WIDTH 8
      tt-regra-form-preco.val-faixa-fim FORMAT "->,>>>,>>9.9999":U WIDTH 8
      fnDescAbrangen(tt-regra-form-preco.cdn-abrangen) FORMAT "x(20)" COLUMN-LABEL 'Abrangˆncia' WIDTH 12
      fnFormataColunaChar('cod-pto-coleta',  tt-regra-form-preco.cdn-abrangen, tt-regra-form-preco.cod-pto-coleta)FORMAT "x(12)":U COLUMN-LABEL 'Pto. Coleta' WIDTH 9
      fnFormataColunaChar('cod-propried',  tt-regra-form-preco.cdn-abrangen, tt-regra-form-preco.cod-propried)FORMAT "x(16)":U COLUMN-LABEL 'Propriedade' WIDTH 9
      fnFormataColunaInt('cdn-produt-rural',  tt-regra-form-preco.cdn-abrangen, tt-regra-form-preco.cdn-produt-rural)FORMAT "x(12)":U COLUMN-LABEL 'Produtor' WIDTH 9
      fnFormataColunaInt('cdn-grp-produt',  tt-regra-form-preco.cdn-abrangen, tt-regra-form-preco.cdn-grp-produt) FORMAT "x(6)":U COLUMN-LABEL 'Grupo' WIDTH 6
      fnFormataColunaChar('cod-rota',  tt-regra-form-preco.cdn-abrangen, tt-regra-form-preco.cod-rota) FORMAT "x(12)":U COLUMN-LABEL 'Rota' WIDTH 9
      fnFormataColunaChar('cod-regiao',  tt-regra-form-preco.cdn-abrangen, tt-regra-form-preco.cod-regiao) FORMAT "x(12)":U COLUMN-LABEL 'RegiÆo' WIDTH 9
      fnFormataColunaChar('cod-estabel', tt-regra-form-preco.cdn-abrangen, tt-regra-form-preco.cod-estabel) FORMAT "x(5)":U COLUMN-LABEL 'Estabel' WIDTH 7
      tt-regra-form-preco.cod-exame FORMAT ">>>>>9":U COLUMN-LABEL 'Exame' 
      tt-regra-form-preco.cod-comp FORMAT ">>>9":U  COLUMN-LABEL 'Comp'
      fnDescAplicacao(tt-regra-form-preco.cdn-aplic) FORMAT "x(30)" COLUMN-LABEL 'Apl Exced' WIDTH 10
      tt-regra-form-preco.cod-usuar-criac FORMAT "x(12)":U COLUMN-LABEL 'Usu rio Criac'
      tt-regra-form-preco.dat-criac FORMAT "99/99/9999":U COLUMN-LABEL 'Dt Criac'
      tt-regra-form-preco.cod-usuar-alter FORMAT "x(12)":U COLUMN-LABEL 'Usu rio Alter'
      tt-regra-form-preco.dat-alter FORMAT "99/99/9999":U COLUMN-LABEL 'Dt Alter'
      tt-regra-form-preco.descricao FORMAT "x(200)":U WIDTH 15  COLUMN-LABEL 'Descri‡Æo Regra'
      tt-regra-form-preco.it-codigo FORMAT "x(16)":U
      fnDescItem(tt-regra-form-preco.it-codigo) COLUMN-LABEL 'Descri‡Æo' WIDTH 15 FORMAT "X(200)"
      tt-regra-form-preco.des-narrat FORMAT "x(2000)":U WIDTH 250
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS MULTIPLE SIZE 111 BY 15.25
         FONT 1
         TITLE "Regras" FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fpage0
     btSelecao AT ROW 1.13 COL 1.14 HELP
          "Ocorrˆncia anterior"
     btCopia AT ROW 1.13 COL 5.57 HELP
          "Primeira ocorrˆncia"
     btQueryJoins AT ROW 1.13 COL 97.57 HELP
          "Consultas relacionadas"
     btReportsJoins AT ROW 1.13 COL 101.57 HELP
          "Relat¢rios relacionados"
     btExit AT ROW 1.13 COL 105.57 HELP
          "Sair"
     btHelp AT ROW 1.13 COL 109.57 HELP
          "Ajuda"
     brSon1 AT ROW 2.75 COL 2.14
     btIncluir AT ROW 18.17 COL 2
     btModificar AT ROW 18.17 COL 12
     btEliminar AT ROW 18.17 COL 22
     fi_key AT ROW 18.25 COL 49 COLON-ALIGNED NO-LABEL
     rtToolBar AT ROW 1 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 113 BY 18.38
         FONT 1.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Maintenance
   Allow: Basic,Browse,DB-Fields,Window,Query
   Add Fields to: Neither
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW wMaintenance ASSIGN
         HIDDEN             = YES
         TITLE              = ""
         HEIGHT             = 18.38
         WIDTH              = 113
         MAX-HEIGHT         = 38.63
         MAX-WIDTH          = 182.86
         VIRTUAL-HEIGHT     = 38.63
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

ASSIGN {&WINDOW-NAME}:MENUBAR    = MENU mbMain:HANDLE.
/* END WINDOW DEFINITION                                                */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB wMaintenance 
/* ************************* Included-Libraries *********************** */

{maintenance/maintenance.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW wMaintenance
  NOT-VISIBLE,,RUN-PERSISTENT                                           */
/* SETTINGS FOR FRAME fpage0
   FRAME-NAME                                                           */
/* BROWSE-TAB brSon1 btHelp fpage0 */
/* SETTINGS FOR FILL-IN fi_key IN FRAME fpage0
   NO-DISPLAY NO-ENABLE                                                 */
ASSIGN 
       fi_key:HIDDEN IN FRAME fpage0           = TRUE.

IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wMaintenance)
THEN wMaintenance:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE brSon1
/* Query rebuild information for BROWSE brSon1
     _START_FREEFORM
OPEN QUERY {&SELF-NAME} FOR EACH tt-regra-form-preco NO-LOCK
    BY tt-regra-form-preco.cdn-tipo
    BY tt-regra-form-preco.dat-inic
    BY tt-regra-form-preco.cod-regra
    BY tt-regra-form-preco.cdn-seq
    BY tt-regra-form-preco.cdn-abrangen
    BY tt-regra-form-preco.cod-pto-coleta
    BY tt-regra-form-preco.cod-propried
    BY tt-regra-form-preco.cdn-produt-rural
    BY tt-regra-form-preco.cdn-grp-produt
    BY tt-regra-form-preco.cod-rota
    BY tt-regra-form-preco.cod-regiao
    BY tt-regra-form-preco.cod-estabel.
     _END_FREEFORM
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _Query            is OPENED
*/  /* BROWSE brSon1 */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME fpage0
/* Query rebuild information for FRAME fpage0
     _Options          = "SHARE-LOCK KEEP-EMPTY"
     _Query            is NOT OPENED
*/  /* FRAME fpage0 */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME wMaintenance
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wMaintenance wMaintenance
ON END-ERROR OF wMaintenance
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wMaintenance wMaintenance
ON WINDOW-CLOSE OF wMaintenance
DO:
  /* This event will close the window and terminate the procedure.  */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME brSon1
&Scoped-define SELF-NAME brSon1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL brSon1 wMaintenance
ON MOUSE-SELECT-CLICK OF brSon1 IN FRAME fpage0 /* Regras */
DO:
  APPLY 'VALUE-CHANGED':U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL brSon1 wMaintenance
ON VALUE-CHANGED OF brSon1 IN FRAME fpage0 /* Regras */
DO: 
    ASSIGN btModificar:SENSITIVE = brSon1:NUM-SELECTED-ROWS  = 1
           btEliminar:SENSITIVE  = brSon1:NUM-SELECTED-ROWS >= 1.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btCopia
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btCopia wMaintenance
ON CHOOSE OF btCopia IN FRAME fpage0
OR CHOOSE OF MENU-ITEM miCopiar
DO: 
    DEFINE VARIABLE iTipoRegra AS INTEGER NO-UNDO.
        
    FIND FIRST tt-regra-form-preco NO-ERROR.
    IF AVAIL tt-regra-form-preco AND NOT l-consulta THEN DO:        
        ASSIGN iTipoRegra = tt-regra-form-preco.cdn-tipo.
    
        IF CAN-FIND (FIRST tt-regra-form-preco WHERE tt-regra-form-preco.cdn-tipo <> iTipoRegra )THEN DO:
           RUN utp/ut-msgs.p (INPUT 'show', /*NÆo ‚ poss¡vel realizar a C¢pia/Reajuste.*/
                              INPUT 54646,
                              INPUT '').
           {&WINDOW-NAME}:SENSITIVE = YES.
            RETURN NO-APPLY.
        END.
    
        {&WINDOW-NAME}:SENSITIVE = NO.
        RUN aqp/aq0201c.w(INPUT TABLE tt-regra-form-preco).
        IF RETURN-VALUE = 'OK':U THEN
            RUN piOpenQuery IN THIS-PROCEDURE.
        {&WINDOW-NAME}:SENSITIVE = YES.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btEliminar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btEliminar wMaintenance
ON CHOOSE OF btEliminar IN FRAME fpage0 /* Eliminar */
OR ALT-E OF {&WINDOW-NAME} ANYWHERE 
DO:
    IF AVAIL tt-regra-form-preco AND NOT l-consulta THEN DO:

        DEFINE VARIABLE cont AS INTEGER NO-UNDO.

        RUN utp/ut-msgs.p ( INPUT "show":U, INPUT 550, INPUT "" ).

        IF  RETURN-VALUE = "no":U THEN
            RETURN NO-APPLY.
        
        EMPTY TEMP-TABLE tt-selected-rows NO-ERROR.
        EMPTY TEMP-TABLE rowErrors NO-ERROR.
        RUN emptyRowErrors IN {&hDBOTable}.

        DO cont = 1 TO brSon1:NUM-SELECTED-ROWS:
           IF brSon1:FETCH-SELECTED-ROW(cont) THEN DO:
               CREATE tt-selected-rows.
               ASSIGN tt-selected-rows.r-rowid = tt-regra-form-preco.r-rowid.
           END.
        END.

        RUN deleteRecordCustom IN {&hDBOTable}(INPUT-OUTPUT TABLE tt-selected-rows).
        
        /* Apaga do browse registros eliminados */
        FOR EACH tt-regra-form-preco:
            IF CAN-FIND(FIRST tt-selected-rows 
                        WHERE tt-selected-rows.r-rowid = tt-regra-form-preco.r-rowid
                          AND tt-selected-rows.l-eliminou) THEN DO:
                DELETE tt-regra-form-preco.
            END.
        END.

        RUN getRowErrors IN {&hDBOTable}(OUTPUT TABLE RowErrors).

        IF CAN-FIND(FIRST RowErrors) THEN DO:
            {method/showmessage.i1}
            /*--- Transfere temp-table RowErrors para a tela de mensagens de erros ---*/
            {method/showmessage.i2}
        END.

        {&OPEN-QUERY-brSon1}

        APPLY 'VALUE-CHANGED':U TO brSon1 IN FRAME fPage0.

        EMPTY TEMP-TABLE tt-selected-rows NO-ERROR.
        EMPTY TEMP-TABLE rowErrors NO-ERROR.
        RUN emptyRowErrors IN {&hDBOTable}.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btExit
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btExit wMaintenance
ON CHOOSE OF btExit IN FRAME fpage0 /* Exit */
OR CHOOSE OF MENU-ITEM miExit IN MENU mbMain DO:
    APPLY "CLOSE":U TO THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btHelp
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btHelp wMaintenance
ON CHOOSE OF btHelp IN FRAME fpage0 /* Help */
OR CHOOSE OF MENU-ITEM miContents IN MENU mbMain DO:
    {include/ajuda.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btIncluir
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btIncluir wMaintenance
ON CHOOSE OF btIncluir IN FRAME fpage0 /* Incluir */
OR ALT-I OF {&WINDOW-NAME} ANYWHERE 
DO:
    IF NOT l-consulta THEN DO:
        {&WINDOW-NAME}:SENSITIVE = NO.
        
        FIND FIRST tt-param NO-ERROR.
        RUN aqp/aq0201b.w(INPUT ?, INPUT tt-param.it-codigo).
        
        IF RETURN-VALUE = 'OK' THEN
            RUN piOpenQuery IN THIS-PROCEDURE.
        
        {&WINDOW-NAME}:SENSITIVE = YES.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btModificar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btModificar wMaintenance
ON CHOOSE OF btModificar IN FRAME fpage0 /* Modificar */
OR ALT-A OF {&WINDOW-NAME} ANYWHERE 
DO:
    IF AVAIL tt-regra-form-preco AND NOT l-consulta THEN DO:
        {&WINDOW-NAME}:SENSITIVE = NO.
        RUN aqp/aq0201b.w(INPUT tt-regra-form-preco.r-rowid, INPUT ?).
        IF RETURN-VALUE = 'OK' THEN
           RUN piOpenQuery IN THIS-PROCEDURE.

        {&WINDOW-NAME}:SENSITIVE = YES.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btQueryJoins
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btQueryJoins wMaintenance
ON CHOOSE OF btQueryJoins IN FRAME fpage0 /* Query Joins */
OR CHOOSE OF MENU-ITEM miQueryJoins IN MENU mbMain DO:
    RUN showQueryJoins IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btReportsJoins
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btReportsJoins wMaintenance
ON CHOOSE OF btReportsJoins IN FRAME fpage0 /* Reports Joins */
OR CHOOSE OF MENU-ITEM miReportsJoins IN MENU mbMain DO:
    RUN showReportsJoins IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btSelecao
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btSelecao wMaintenance
ON CHOOSE OF btSelecao IN FRAME fpage0
OR CHOOSE OF MENU-ITEM miSelec 
DO:
    {&WINDOW-NAME}:SENSITIVE = NO.

    RUN aqp/aq0201a.w(INPUT-OUTPUT TABLE tt-param).
    IF RETURN-VALUE = "OK" THEN
        RUN piOpenQuery IN THIS-PROCEDURE.

    ASSIGN btModificar:SENSITIVE = brSon1:NUM-SELECTED-ROWS  = 1
           btEliminar:SENSITIVE  = brSon1:NUM-SELECTED-ROWS >= 1.

    {&WINDOW-NAME}:SENSITIVE = YES.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME miAbout
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL miAbout wMaintenance
ON CHOOSE OF MENU-ITEM miAbout /* Sobre... */
DO:
  {include/sobre.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wMaintenance 


/*:T--- L¢gica para inicializa‡Æo do programam ---*/
{maintenance/mainblock.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterDestroyInterface wMaintenance 
PROCEDURE afterDestroyInterface :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    IF VALID-HANDLE({&hDBOTable}) THEN DO:
        DELETE PROCEDURE {&hDBOTable}.
        ASSIGN {&hDBOTable} = ?.
    END.

    IF VALID-HANDLE(h-boin172) THEN DO:
        DELETE PROCEDURE h-boin172.
        ASSIGN h-boin172 = ?.
    END.

    IF VALID-HANDLE(h-aqapi001) THEN DO:
        DELETE PROCEDURE h-aqapi001.
        ASSIGN h-aqapi001 = ?.
    END.    

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterEnableFields wMaintenance 
PROCEDURE afterEnableFields :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    /*ENABLE btIncluir WITH FRAME fpage0.
    
    VIEW brSon1 IN FRAME fpage0.
    
    APPLY "ENTRY":U TO wMaintenance.*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterInitializeInterface wMaintenance 
PROCEDURE afterInitializeInterface :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    VIEW FRAME fpage0.
    
    ENABLE btIncluir btModificar  btCopia 
           btSelecao btQueryJoins btReportsJoins 
           brSon1 WITH FRAME fpage0.

    {utp/ut-liter.i Sim *}
    ASSIGN cColumnLabel[2] = RETURN-VALUE.
    {utp/ut-liter.i NÆo *}
    ASSIGN cColumnLabel[1] = RETURN-VALUE.

    APPLY 'VALUE-CHANGED':U TO brSon1 IN FRAME fPage0.

    RUN piCriaTTParamDefault IN THIS-PROCEDURE.
    
    ASSIGN btCopia:SENSITIVE = NO
            l-consulta = "{1}":U = "AQ0421":U.
  
    IF l-consulta THEN DO:
      ASSIGN btCopia    :HIDDEN IN FRAME fPage0 = TRUE
             btIncluir  :HIDDEN IN FRAME fPage0 = TRUE
             btModificar:HIDDEN IN FRAME fPage0 = TRUE
             btEliminar :HIDDEN IN FRAME fPage0 = TRUE
             MENU-ITEM miCopiar:SENSITIVE IN MENU smFile  = NO.      
    END.

    RETURN 'OK':U.    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE goToRecord wMaintenance 
PROCEDURE goToRecord :
/*:T------------------------------------------------------------------------------
  Purpose:     Exibe dialog de V  Para
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
    /*DEFINE BUTTON btGoToCancel AUTO-END-KEY 
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
    
    DEFINE VARIABLE <c|d|i><campo 1> LIKE {&ttTable}.<campo 1> NO-UNDO.
    DEFINE VARIABLE <c|d|i><campo 2> LIKE {&ttTable}.<campo 2> NO-UNDO.
    
    DEFINE FRAME fGoToRecord
        <c|d|i><campo 1>  AT ROW 1.21 COL 17.72 COLON-ALIGNED
        <c|d|i><campo 2>  AT ROW 2.21 COL 17.72 COLON-ALIGNED
        btGoToOK          AT ROW 3.63 COL 2.14
        btGoToCancel      AT ROW 3.63 COL 13
        rtGoToButton      AT ROW 3.38 COL 1
        SPACE(0.28)
        WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER SIDE-LABELS NO-UNDERLINE 
             THREE-D SCROLLABLE TITLE "V  Para <Tabela>" FONT 1
             DEFAULT-BUTTON btGoToOK CANCEL-BUTTON btGoToCancel.
    
/*tech1139 - FO 1338.917 - 10/07/2006  */
    RUN utp/ut-trfrrp.p (input Frame fGoToRecord:Handle).
    {utp/ut-liter.i "V _Para_<tabela>"}
    ASSIGN FRAME fGoToRecord:TITLE = RETURN-VALUE.
/*tech1139 - FO 1338.917 - 10/07/2006  */

    ON "CHOOSE":U OF btGoToOK IN FRAME fGoToRecord DO:
        ASSIGN <c|d|i><campo 1> <c|d|i><campo 2>.
        
        RUN goToKey IN {&hDBOTable} (INPUT <c|d|i><campo 1> , INPUT <c|d|i><campo 2> ).
        IF RETURN-VALUE = "NOK":U THEN DO:
            RUN utp/ut-msgs.p (INPUT "SHOW":U, INPUT 2, INPUT "<Table>":U).
            
            RETURN NO-APPLY.
        END.
        
        /*:T Retorna rowid do registro corrente do DBO */
        RUN getRowid IN {&hDBOTable} (OUTPUT rGoTo).
        
        /*:T Reposiciona registro com base em um rowid */
        RUN repositionRecord IN THIS-PROCEDURE (INPUT rGoTo).

        APPLY "GO":U TO FRAME fGoToRecord.
    END.
    
    ENABLE <c|d|i><campo 1> <c|d|i><campo 2> btGoToOK btGoToCancel 
        WITH FRAME fGoToRecord. 
    
    WAIT-FOR "GO":U OF FRAME fGoToRecord.*/
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE initializeDBOs wMaintenance 
PROCEDURE initializeDBOs :
/*:T------------------------------------------------------------------------------
  Purpose:     Inicializa DBOs
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
    
    /*:T--- Verifica se o DBO j  est  inicializado ---*/
    IF NOT VALID-HANDLE({&hDBOTable}) OR
       {&hDBOTable}:TYPE <> "PROCEDURE":U OR
       {&hDBOTable}:FILE-NAME <> "inbo/boin00972.p":U THEN DO:
        {btb/btb008za.i1 inbo/boin00972.p YES}
        {btb/btb008za.i2 inbo/boin00972.p '' {&hDBOTable}}
    END.
    
    IF NOT VALID-HANDLE(h-aqapi001) THEN DO:
        RUN aqp/aqapi001.p PERSISTENT SET h-aqapi001.
    END.
    
    IF NOT VALID-HANDLE(h-boin172) THEN DO: /* item */
        {btb/btb008za.i1 inbo/boin172.p}
        {btb/btb008za.i2 inbo/boin172.p '' h-boin172}
    END.
    RUN openQueryStatic IN h-boin172 (INPUT "Main":U).
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piCriaTTParamDefault wMaintenance 
PROCEDURE piCriaTTParamDefault :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    EMPTY TEMP-TABLE tt-param NO-ERROR.

    CREATE tt-param.
    ASSIGN tt-param.da-dat-ini           = fnVigencia(1)
           tt-param.da-dat-fim           = fnVigencia(2)
           tt-param.cod-estabel-fim      = FILL('Z',5)
           tt-param.cod-regiao-fim       = FILL('Z',12)
           tt-param.cdn-grp-produt-fim   = INTEGER(FILL('9', 6))
           tt-param.cdn-produt-rural-fim = INTEGER(FILL('9',9))
           tt-param.cod-pto-coleta-fim   = FILL("Z",12)
           tt-param.cdn-tipo             = 5 /* todos */
           tt-param.cod-regra-fim        = FILL("Z",20)
           tt-param.cod-exame-fim        = INTEGER(FILL('9',6))
           tt-param.cod-comp-fim         = INTEGER(FILL('9',4))
           tt-param.cod-rota-fim         = FILL("Z",12)
           tt-param.cod-propried-fim     = FILL("Z",16).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piOpenQuery wMaintenance 
PROCEDURE piOpenQuery :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    EMPTY TEMP-TABLE tt-regra-form-preco NO-ERROR.    

    RUN piGetFaixaValida IN h-aqapi001(INPUT TABLE tt-param,
                                       INPUT 'aq0201':U, 
                                       OUTPUT TABLE tt-regra-form-preco).
    {&OPEN-QUERY-brSon1}

    ASSIGN btCopia:SENSITIVE IN FRAME fPage0 = CAN-FIND(FIRST tt-regra-form-preco).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fnDescAbrangen wMaintenance 
FUNCTION fnDescAbrangen RETURNS CHARACTER
  ( iCdnAbrangen AS INTEGER ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  RETURN {ininc/i01in00972.i 04 iCdnAbrangen}.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fnDescAplicacao wMaintenance 
FUNCTION fnDescAplicacao RETURNS CHARACTER
  ( iCdnAplic AS INTEGER ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  RETURN cColumnLabel[iCdnAplic].   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fnDescItem wMaintenance 
FUNCTION fnDescItem RETURNS CHARACTER
  ( cItCodigo AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
    DEFINE VARIABLE c-descricao LIKE item.desc-item NO-UNDO.

    RUN goToKey in h-boin172 (INPUT cItCodigo).
    IF RETURN-VALUE = "Ok" then
        RUN getCharField in h-boin172 (INPUT "desc-item":U, OUTPUT c-descricao).

    RETURN c-descricao.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fnDescTipo wMaintenance 
FUNCTION fnDescTipo RETURNS CHARACTER
  ( iCdnTipo AS INTEGER ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

  RETURN {ininc/i02in00972.i 04 iCdnTipo}.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fnFormataColunaChar wMaintenance 
FUNCTION fnFormataColunaChar RETURNS CHARACTER
  ( cCampo AS CHARACTER, iCdnAbrangen AS INTEGER, cValor AS CHARACTER) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
    DEF VAR cReturn AS CHARACTER NO-UNDO.

    CASE iCdnAbrangen:
        WHEN 1 THEN ASSIGN cReturn = IF cCampo = 'cod-pto-coleta':U   THEN cValor ELSE "*".
        WHEN 2 THEN ASSIGN cReturn = IF cCampo = 'cod-propried'       THEN cValor ELSE "*".
        WHEN 3 THEN ASSIGN cReturn = IF cCampo = 'cdn-produt-rural':U THEN cValor ELSE "*".
        WHEN 4 THEN ASSIGN cReturn = IF cCampo = 'cdn-grp-produt':U   THEN cValor ELSE "*".
        WHEN 5 THEN ASSIGN cReturn = IF cCampo = 'cod-rota':U         THEN cValor ELSE "*".
        WHEN 6 THEN ASSIGN cReturn = IF cCampo = 'cod-regiao':U       THEN cValor ELSE "*".
        WHEN 7 THEN ASSIGN cReturn = IF cCampo = 'cod-estabel':U      THEN cValor ELSE "*".
        OTHERWISE cReturn = "*".
    END CASE.

    RETURN cReturn.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fnFormataColunaInt wMaintenance 
FUNCTION fnFormataColunaInt RETURNS CHARACTER
  ( cCampo AS CHARACTER, iCdnAbrangen AS INTEGER, iValor AS INT) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
    DEF VAR cReturn AS CHARACTER NO-UNDO.

    CASE iCdnAbrangen:
        WHEN 1 THEN ASSIGN cReturn = IF cCampo = 'cod-pto-coleta'   THEN STRING(iValor) ELSE "*".
        WHEN 2 THEN ASSIGN cReturn = IF cCampo = 'cod-propried'     THEN STRING(iValor) ELSE "*".
        WHEN 3 THEN ASSIGN cReturn = IF cCampo = 'cdn-produt-rural' THEN STRING(iValor) ELSE "*".
        WHEN 4 THEN ASSIGN cReturn = IF cCampo = 'cdn-grp-produt'   THEN STRING(iValor) ELSE "*".
        WHEN 5 THEN ASSIGN cReturn = IF cCampo = 'cod-rota'         THEN STRING(iValor) ELSE "*".
        WHEN 6 THEN ASSIGN cReturn = IF cCampo = 'cod-regiao'       THEN STRING(iValor) ELSE "*".
        WHEN 7 THEN ASSIGN cReturn = IF cCampo = 'cod-estabel'      THEN STRING(iValor) ELSE "*".
        OTHERWISE cReturn = "*".
    END CASE.

    RETURN cReturn.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fnVigencia wMaintenance 
FUNCTION fnVigencia RETURNS DATE
  ( i AS INTEGER ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
    DEFINE VARIABLE dtAtual      AS INTEGER EXTENT 2 NO-UNDO.
    DEFINE VARIABLE mesAnt       AS INTEGER          NO-UNDO.
    DEFINE VARIABLE anoIni       AS INTEGER          NO-UNDO.
    DEFINE VARIABLE dtDataVigenc AS DATE    EXTENT 2 NO-UNDO.
    
    ASSIGN dtAtual[1] = MONTH(TODAY) /* mes corrente */
           dtAtual[2] = YEAR(TODAY)  /* ano corrente */
           mesant = dtAtual[1] - 1   /* mes anterior */
           anoini = dtAtual[2].      /* ano data inicial vigencia */
    
    /* Se for o mes um, atializa mes anterior com o mes 12*/
    IF dtAtual[1] = 1 THEN
        ASSIGN mesant = 12
               anoini  = dtAtual[2] - 1. /* ano anterior */
    
    ASSIGN dtDataVigenc[1] = DATE(mesant,1,anoini). /* Primeiro dia do mes */
           dtDataVigenc[2] = DATE(dtAtual[1],1,dtAtual[2]) - 1. /* ultimo dia do mes */
    
    RETURN dtDataVigenc[i].

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

