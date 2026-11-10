&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
*/
&Scoped-define WINDOW-NAME wMasterDetail


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE tt-docum-est-rateio NO-UNDO LIKE docum-est
       field r-rowid as rowid
       field nome-abrev as char format "x(12)".
DEFINE TEMP-TABLE tt-embarque-imp NO-UNDO LIKE embarque-imp
       field r-rowid as rowid.



&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS wMasterDetail 
/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i IM0545G 2.00.00.013 } /*** "010013" 10/04/2026 11:05:54 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i im0545g MIM}
&ENDIF

/********************************************************************************
** Copyright DATASUL S.A. (1999)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/

CREATE WIDGET-POOL.
{cdp/cdcfgmat.i}

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program          IM0545G
&GLOBAL-DEFINE Version        2.00.00.013
&GLOBAL-DEFINE DBOVersion       1.1

&GLOBAL-DEFINE Folder           NO
&GLOBAL-DEFINE InitialPage      1
&GLOBAL-DEFINE FramesHandle     STRING(FRAME fPage1:HANDLE)
&GLOBAL-DEFINE FolderLabels     Embarques Relacionados, Documentos

&GLOBAL-DEFINE ttParent         tt-embarque-imp
&GLOBAL-DEFINE hDBOParent       h-bocx220
&GLOBAL-DEFINE DBOParentTable   embarque-imp

&GLOBAL-DEFINE ttSon1           tt-embarque-rel
&GLOBAL-DEFINE hDBOSon1         h-boin220-1
&GLOBAL-DEFINE DBOSon1Table     embarque-imp

&GLOBAL-DEFINE ttSon2           tt-documentos
&GLOBAL-DEFINE hDBOSon2         h-boin090a
&GLOBAL-DEFINE DBOSon2Table     docum-est

&GLOBAL-DEFINE page0Fields      c-invisivel
&GLOBAL-DEFINE page1Fields      c-text-doc
&GLOBAL-DEFINE page2Fields      c-text-doc-comp
    
&GLOBAL-DEFINE page1Browse      brSon1
&GLOBAL-DEFINE page2Browse      brSon2 

&GLOBAL-DEFINE EXCLUDE-applyOffEnd
&GLOBAL-DEFINE EXCLUDE-applyEnd

&GLOBAL-DEFINE VALUE-CHANGED1   YES

/* Parameters Definitions ---                                           */
def input param pcod-estabel as char no-undo.
def input param pembarque    LIKE embarque-imp.embarque no-undo.

/* Local Variable Definitions ---                                       */
DEFINE VARIABLE c-estabel-docto  AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-embarque-docto AS CHARACTER   NO-UNDO.
DEFINE VARIABLE l-primeira-exec  AS LOGICAL     NO-UNDO.

/* Local Variable Definitions (DBOs Handles) ---                        */
DEFINE VARIABLE {&hDBOParent} AS HANDLE NO-UNDO.
DEFINE VARIABLE {&hDBOSon1}   AS HANDLE NO-UNDO.
DEFINE VARIABLE {&hDBOSon2}   AS HANDLE NO-UNDO.

define new global shared variable gc-spp-cod-estabel LIKE embarque-imp.cod-estabel no-undo.
define new global shared variable gc-spp-embarque    LIKE embarque-imp.embarque    no-undo.
 
{cdp/cd4300.i3}
{ccp/cc9019.i50}

DEFINE TEMP-TABLE tt-documentos NO-UNDO
    field embarque                   LIKE embarque-imp.embarque      
    field cod-estabel                LIKE embarque-imp.cod-estabel   
    field nro-docto                  LIKE docum-est.nro-docto
    field serie-docto                LIKE docum-est.serie-docto   
    field cod-emitente               LIKE docum-est.cod-emitente
    field nat-operacao               LIKE docum-est.nat-operacao
    field idi-nf-simples-remes       LIKE docum-est.idi-nf-simples-remes
    field dt-emissao                 LIKE docum-est.dt-emissao
    field usuario                    LIKE docum-est.usuario                          
    field ce-atual                   LIKE docum-est.ce-atual	
    field embarque-ori               LIKE embarque-imp.embarque
    field log-nota-ajust-import      LIKE item-doc-est.log-nota-ajust-import
    field cod-tipo-nf-cred-deb       LIKE docum-est.cod-tipo-nf-cred-deb
    field cod-finalidade             LIKE docum-est.cod-finalidade
    field observ-pagto               AS CHAR
    field r-rowid as rowid
.   

DEFINE TEMP-TABLE tt-embarque-rel NO-UNDO
    FIELD embarque      LIKE embarque-imp.embarque
    FIELD cod-estabel   LIKE embarque-imp.cod-estabel
    FIELD embarque-orig LIKE embarque-imp.embarque
    FIELD r-rowid AS ROWID.

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
&Scoped-define INTERNAL-TABLES tt-embarque-rel tt-documentos

/* Definitions for BROWSE brSon1                                        */
&Scoped-define FIELDS-IN-QUERY-brSon1 tt-embarque-rel.embarque tt-embarque-rel.cod-estabel tt-embarque-rel.embarque-orig   
&Scoped-define ENABLED-FIELDS-IN-QUERY-brSon1   
&Scoped-define SELF-NAME brSon1
&Scoped-define QUERY-STRING-brSon1 FOR EACH tt-embarque-rel NO-LOCK
&Scoped-define OPEN-QUERY-brSon1 OPEN QUERY {&SELF-NAME} FOR EACH tt-embarque-rel NO-LOCK.
&Scoped-define TABLES-IN-QUERY-brSon1 tt-embarque-rel
&Scoped-define FIRST-TABLE-IN-QUERY-brSon1 tt-embarque-rel


/* Definitions for BROWSE brSon2                                        */
&Scoped-define FIELDS-IN-QUERY-brSon2 tt-documentos.cod-estabel tt-documentos.serie-docto tt-documentos.cod-emitente tt-documentos.nat-operacao tt-documentos.nro-docto tt-documentos.dt-emissao tt-documentos.ce-atual tt-documentos.usuario fnTipoDocumento(tt-documentos.idi-nf-simples-remes , tt-documentos.nat-operacao, tt-documentos.log-nota-ajust-import, tt-documentos.cod-tipo-nf-cred-deb, tt-documentos.cod-finalidade) tt-documentos.observ-pagto
&Scoped-define ENABLED-FIELDS-IN-QUERY-brSon2   
&Scoped-define SELF-NAME brSon2
&Scoped-define QUERY-STRING-brSon2 FOR EACH tt-documentos NO-LOCK
&Scoped-define OPEN-QUERY-brSon2 OPEN QUERY {&SELF-NAME} FOR EACH tt-documentos NO-LOCK.
&Scoped-define TABLES-IN-QUERY-brSon2 tt-documentos
&Scoped-define FIRST-TABLE-IN-QUERY-brSon2 tt-documentos


/* Definitions for FRAME fPage1                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-fPage1 ~
    ~{&OPEN-QUERY-brSon1}

/* Definitions for FRAME fPage2                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-fPage2 ~
    ~{&OPEN-QUERY-brSon2}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS rtToolBar btQueryJoins btReportsJoins btExit ~
btHelp c-invisivel 
&Scoped-Define DISPLAYED-OBJECTS c-invisivel 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnTipoDocumento wMasterDetail 
FUNCTION fnTipoDocumento RETURNS CHARACTER
  ( pidi-nf-simples-remes  AS INT,
    pnat-operacao AS CHAR,
    pnf-ajust-import AS LOG,
    pcod-tipo-nf-cred-deb as char,
    pcod-finalidade as char) FORWARD.  

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR wMasterDetail AS WIDGET-HANDLE NO-UNDO.

/* Menu Definitions                                                     */
DEFINE SUB-MENU smFile 
       MENU-ITEM miFirst        LABEL "&Primeiro"      ACCELERATOR "CTRL-HOME"
              DISABLED
       MENU-ITEM miPrev         LABEL "&Anterior"      ACCELERATOR "CTRL-CURSOR-LEFT"
              DISABLED
       MENU-ITEM miNext         LABEL "&Pr¢ximo"       ACCELERATOR "CTRL-CURSOR-RIGHT"
              DISABLED
       MENU-ITEM miLast         LABEL "&Èltimo"        ACCELERATOR "CTRL-END"
              DISABLED
       RULE
       MENU-ITEM miGoTo         LABEL "&V† Para"       ACCELERATOR "CTRL-T"
              DISABLED
       MENU-ITEM miSearch       LABEL "&Pesquisa"      ACCELERATOR "CTRL-F5"
              DISABLED
       RULE
       MENU-ITEM miAdd          LABEL "&Incluir"       ACCELERATOR "CTRL-INS"
              DISABLED
       MENU-ITEM miCopy         LABEL "&Copiar"        ACCELERATOR "CTRL-C"
              DISABLED
       MENU-ITEM miUpdate       LABEL "&Alterar"       ACCELERATOR "CTRL-A"
              DISABLED
       MENU-ITEM miDelete       LABEL "&Eliminar"      ACCELERATOR "CTRL-DEL"
              DISABLED
       RULE
       MENU-ITEM miQueryJoins   LABEL "&Consultas"    
              DISABLED
       MENU-ITEM miReportsJoins LABEL "&Relat¢rios"   
              DISABLED
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
     IMAGE-UP FILE "image\im-exi":U
     IMAGE-INSENSITIVE FILE "image\ii-exi":U
     LABEL "Exit" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE BUTTON btHelp 
     IMAGE-UP FILE "image\im-hel":U
     IMAGE-INSENSITIVE FILE "image\ii-hel":U
     LABEL "Help" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE BUTTON btQueryJoins 
     IMAGE-UP FILE "image\im-joi":U
     IMAGE-INSENSITIVE FILE "image\ii-joi":U
     LABEL "Query Joins" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE BUTTON btReportsJoins 
     IMAGE-UP FILE "image\im-pri":U
     IMAGE-INSENSITIVE FILE "image\ii-pri":U
     LABEL "Reports Joins" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE VARIABLE c-invisivel AS CHARACTER FORMAT "X(256)":U 
      VIEW-AS TEXT 
     SIZE .2 BY .2 NO-UNDO.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 90 BY 1.5
     BGCOLOR 7 .

DEFINE VARIABLE c-text-doc AS CHARACTER FORMAT "X(256)":U INITIAL "Embarques Relacionados" 
      VIEW-AS TEXT 
     SIZE 21 BY .67 NO-UNDO.

DEFINE VARIABLE c-text-doc-comp AS CHARACTER FORMAT "X(256)":U INITIAL "Documentos" 
      VIEW-AS TEXT 
     SIZE 14.14 BY .67 NO-UNDO.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY brSon1 FOR 
      tt-embarque-rel SCROLLING.

DEFINE QUERY brSon2 FOR 
      tt-documentos SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE brSon1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS brSon1 wMasterDetail _FREEFORM
  QUERY brSon1 NO-LOCK DISPLAY
      tt-embarque-rel.embarque
tt-embarque-rel.cod-estabel
tt-embarque-rel.embarque-orig COLUMN-LABEL "Emb Origem"
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 30.29 BY 10.96
         FONT 2.

DEFINE BROWSE brSon2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS brSon2 wMasterDetail _FREEFORM
  QUERY brSon2 NO-LOCK DISPLAY
      tt-documentos.cod-estabel
tt-documentos.serie-docto
tt-documentos.cod-emitente
tt-documentos.nat-operacao
tt-documentos.nro-docto
tt-documentos.dt-emissao
tt-documentos.ce-atual
tt-documentos.usuario
fnTipoDocumento(tt-documentos.idi-nf-simples-remes, tt-documentos.nat-operacao, tt-documentos.log-nota-ajust-import, tt-documentos.cod-tipo-nf-cred-deb, tt-documentos.cod-finalidade) COLUMN-LABEL "Tipo Docto" FORMAT "X(22)"
tt-documentos.observ-pagto column-label "Observaá∆o" format "x(55)":U
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 53 BY 11
         FONT 1 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fPage0
     btQueryJoins AT ROW 1.13 COL 74.86 HELP
          "Consultas relacionadas"
     btReportsJoins AT ROW 1.13 COL 78.86 HELP
          "Relat¢rios relacionados"
     btExit AT ROW 1.13 COL 82.86 HELP
          "Sair"
     btHelp AT ROW 1.13 COL 86.86 HELP
          "Ajuda"
     c-invisivel AT ROW 2.63 COL 3.57 NO-LABEL WIDGET-ID 4
     rtToolBar AT ROW 1 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 90 BY 14.88
         FONT 1.

DEFINE FRAME fPage1
     brSon1 AT ROW 2.04 COL 1.72
     c-text-doc AT ROW 1.25 COL 1.72 NO-LABEL WIDGET-ID 6
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 2.43 ROW 3
         SIZE 31.57 BY 12.38
         FONT 1.

DEFINE FRAME fPage2
     brSon2 AT ROW 2 COL 2 WIDGET-ID 200
     c-text-doc-comp AT ROW 1.25 COL 2 NO-LABEL WIDGET-ID 4
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 35 ROW 3
         SIZE 55.29 BY 12.33
         FONT 1 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: MasterDetail
   Allow: Basic,Browse,DB-Fields,Window,Query
   Add Fields to: Neither
   Other Settings: COMPILE
   Temp-Tables and Buffers:
      TABLE: tt-docum-est-rateio T "?" NO-UNDO movind docum-est
      ADDITIONAL-FIELDS:
          field r-rowid as rowid
          field nome-abrev as char format "x(12)"
      END-FIELDS.
      TABLE: tt-embarque-imp T "?" NO-UNDO mgcex embarque-imp
      ADDITIONAL-FIELDS:
          field r-rowid as rowid
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
         HEIGHT             = 14.88
         WIDTH              = 89.86
         MAX-HEIGHT         = 30.63
         MAX-WIDTH          = 114.29
         VIRTUAL-HEIGHT     = 30.63
         VIRTUAL-WIDTH      = 114.29
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
ASSIGN FRAME fPage1:FRAME = FRAME fPage0:HANDLE
       FRAME fPage2:FRAME = FRAME fPage0:HANDLE.

/* SETTINGS FOR FRAME fPage0
   FRAME-NAME                                                           */
/* SETTINGS FOR FILL-IN c-invisivel IN FRAME fPage0
   ALIGN-L                                                              */
ASSIGN 
       c-invisivel:HIDDEN IN FRAME fPage0           = TRUE.

/* SETTINGS FOR FRAME fPage1
                                                                        */
/* BROWSE-TAB brSon1 1 fPage1 */
/* SETTINGS FOR FILL-IN c-text-doc IN FRAME fPage1
   ALIGN-L                                                              */
/* SETTINGS FOR FRAME fPage2
                                                                        */
/* BROWSE-TAB brSon2 1 fPage2 */
/* SETTINGS FOR FILL-IN c-text-doc-comp IN FRAME fPage2
   ALIGN-L                                                              */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wMasterDetail)
THEN wMasterDetail:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE brSon1
/* Query rebuild information for BROWSE brSon1
     _START_FREEFORM
OPEN QUERY {&SELF-NAME} FOR EACH tt-embarque-rel NO-LOCK.
     _END_FREEFORM
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _Query            is OPENED
*/  /* BROWSE brSon1 */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE brSon2
/* Query rebuild information for BROWSE brSon2
     _START_FREEFORM
OPEN QUERY {&SELF-NAME} FOR EACH tt-documentos NO-LOCK.
     _END_FREEFORM
     _Options          = "NO-LOCK"
     _Query            is OPENED
*/  /* BROWSE brSon2 */
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


&Scoped-define BROWSE-NAME brSon1
&Scoped-define FRAME-NAME fPage1
&Scoped-define SELF-NAME brSon1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL brSon1 wMasterDetail
ON VALUE-CHANGED OF brSon1 IN FRAME fPage1
DO:
    IF AVAIL {&ttSon1} THEN DO:
        ASSIGN c-estabel-docto  = {&ttSon1}.cod-estabel
               c-embarque-docto = {&ttSon1}.embarque.
        RUN openQueriesSon IN THIS-PROCEDURE.
    END.
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


&Scoped-define SELF-NAME btHelp
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btHelp wMasterDetail
ON CHOOSE OF btHelp IN FRAME fPage0 /* Help */
OR CHOOSE OF MENU-ITEM miContents IN MENU mbMain DO:
    {include/ajuda.i}
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


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wMasterDetail 


/* ***************************  Main Block  *************************** */
{utp/ut-liter.i "Embarques Relacionados"}
ASSIGN c-text-doc:screen-value    in frame fpage1 = RETURN-VALUE.
{utp/ut-liter.i "Documentos"}
ASSIGN c-text-doc-comp:screen-value    in frame fpage2 = RETURN-VALUE.

/*--- L¢gica para inicializaá∆o do programam ---*/
{masterdetail/mainblock.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterDisplayfields wMasterDetail 
PROCEDURE afterDisplayfields :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE applyEnd wMasterDetail 
PROCEDURE applyEnd :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pPageNumber AS INTEGER NO-UNDO.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE applyOffEnd wMasterDetail 
PROCEDURE applyOffEnd :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pPageNumber AS INTEGER NO-UNDO.

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
    /*--- Verifica se o DBO j† est† inicializado ---*/
    IF NOT VALID-HANDLE({&hDBOParent}) THEN DO:
       RUN cxbo/bocx220.p persistent set {&hDBOParent}.
    END.
    
    &IF DEFINED(DBOVersion) <> 0 &THEN
        RUN openQuery IN {&hDBOParent} (INPUT 2).
    &ELSE
        RUN openQueryStatic IN {&hDBOParent} (INPUT "cod-estabel":U).
    &ENDIF
    
    RUN cxbo/bocx220.p persistent set {&hDBOSon1}.

    RUN inbo/boin090a.p persistent set {&hDBOSon2}.
     
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
    DEFINE VARIABLE i-row AS INTEGER     NO-UNDO.

    IF NOT l-primeira-exec THEN DO:
        /* Embarques relacionados ao embarque corrente (embarques origem e irm∆os) */
        RUN pi-retorna-embarque-relec IN {&hDBOSon1} (INPUT pcod-estabel,
                                                      INPUT pembarque,
                                                      OUTPUT TABLE tt-embarque-rel).
    
        ASSIGN c-estabel-docto  = pcod-estabel
               c-embarque-docto = pembarque.
        {&OPEN-QUERY-brSon1}
        
        /* Seleciona o registro recebido no browse */
        FOR EACH tt-embarque-rel:
            ASSIGN i-row = i-row + 1.
            IF tt-embarque-rel.cod-estabel = pcod-estabel AND tt-embarque-rel.embarque = pembarque THEN LEAVE.
        END.
        BROWSE brSon1:SELECT-ROW(i-row) NO-ERROR.

        ASSIGN l-primeira-exec = YES.
    END.

    run pi-retorna-documentos in {&hDBOSon2} (INPUT c-estabel-docto,
                                              INPUT c-embarque-docto,
                                              OUTPUT TABLE tt-documentos,
                                              OUTPUT TABLE RowErrors).

    {&OPEN-QUERY-brSon2}
    APPLY "VALUE-CHANGED":U TO BROWSE brSon2.
    
    /*Verifica se deve ser emitida a mensagem para executar o 
      spim039 para criar a embarq-import-docto - msg 55448 */
    FIND FIRST RowErrors NO-LOCK
         WHERE RowErrors.ErrorNumber = 55448 NO-ERROR.
    IF AVAIL RowErrors THEN DO:
        RUN utp/ut-msgs.p (input "show":U,
                           input RowErrors.ErrorNumber,
                           input RowErrors.ErrorParameters).
        IF RETURN-VALUE = "YES":U THEN DO:
            ASSIGN gc-spp-cod-estabel = c-estabel-docto
                   gc-spp-embarque    = c-embarque-docto.

            {&window-name}:sensitive = NO.
            session:set-wait-state("general":U).

            RUN spp/imp/spim039.w.

            session:set-wait-state("":U).
            {&window-name}:sensitive = yes.
        END.
    END.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fnTipoDocumento wMasterDetail 
FUNCTION fnTipoDocumento RETURNS CHARACTER
  ( pidi-nf-simples-remes  AS INT,
    pnat-operacao AS CHAR, 
    pnf-ajust-import AS LOG,
    pcod-tipo-nf-cred-deb as char,
    pcod-finalidade as char):
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
    IF pidi-nf-simples-remes = 1 THEN DO: /* "nota m∆e" */
        {utp/ut-liter.i "Nota_M∆e"}
    END.
    ELSE IF pidi-nf-simples-remes = 2 THEN DO: /* nota filha */
         {utp/ut-liter.i "Nota_Filha"}
    END.
    ELSE DO:
        IF CAN-FIND(FIRST natur-oper
                    WHERE natur-oper.nat-operacao = pnat-operacao
                      AND natur-oper.nota-rateio) THEN DO:
            {utp/ut-liter.i "Nota_Complementar"}
        END.
        ELSE DO:
            IF  pcod-tipo-nf-cred-deb = "6" /* Nota de DÇbito */
            AND pcod-finalidade       = "6" /* Pagamento Antecipado */ THEN DO:
               {utp/ut-liter.i "Pagamento_Antecipado"}
            END.
            ELSE        
            IF pnf-ajust-import THEN
               {utp/ut-liter.i "Nota_Ajuste"}
            ELSE
               {utp/ut-liter.i "Nota_Normal"}
        END.
    END.

    RETURN RETURN-VALUE.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

