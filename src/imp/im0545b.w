&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          mgcex            PROGRESS
*/
&Scoped-define WINDOW-NAME wMasterDetail

/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE tt-embarque-imp NO-UNDO LIKE embarque-imp
       field r-rowid as rowid.
DEFINE TEMP-TABLE tt-ordens NO-UNDO LIKE ordens-embarque
       field r-rowid      as rowid
       field valor        as decimal
       field it-codigo    as char
       field data-entrega as date
       field num-pedido   like processo-imp.num-pedido
       field rownum as int
       field desc-item as char.
DEFINE TEMP-TABLE tt-ordens-aux NO-UNDO LIKE ordens-embarque
       field r-rowid      as rowid
       field valor        as decimal
       field desc-item    as char
       field it-codigo    as char
       field data-entrega as date
       field num-pedido   like processo-imp.num-pedido
       field rownum as int.
DEFINE TEMP-TABLE tt-ordens-embarque NO-UNDO LIKE ordens-embarque
       field r-rowid as rowid
       .


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS wMasterDetail 
/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i IM0545B 2.00.00.013 } /*** 010013 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i im0545b MIM}
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

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program          IM0545B
&GLOBAL-DEFINE Version        2.00.00.012
&GLOBAL-DEFINE DBOVersion       1.1

&GLOBAL-DEFINE Folder           YES
&GLOBAL-DEFINE InitialPage      1
&GLOBAL-DEFINE FramesHandle     STRING(FRAME fPage1:HANDLE)
&GLOBAL-DEFINE FolderLabels     Itens

&GLOBAL-DEFINE ttParent         tt-embarque-imp
&GLOBAL-DEFINE hDBOParent       h-bocx220
&GLOBAL-DEFINE DBOParentTable   embarque-imp

&GLOBAL-DEFINE ttSon1           tt-ordens
&GLOBAL-DEFINE hDBOSon1         h-bocx225d
&GLOBAL-DEFINE DBOSon1Table     ordens-embarque

&GLOBAL-DEFINE page0Fields      tt-embarque-imp.cod-estabel ~
                                tt-embarque-imp.embarque
&GLOBAL-DEFINE page1Browse      brSon1
&GLOBAL-DEFINE page2Browse      

/* Parameters Definitions ---                                           */
def input param  pcod-estabel as char no-undo.
def input param  pembarque    LIKE embarque-imp.embarque no-undo.
/* Local Variable Definitions ---                                       */

/* Local Variable Definitions (DBOs Handles) ---                        */
DEFINE VARIABLE {&hDBOParent} AS HANDLE NO-UNDO.
DEFINE VARIABLE {&hDBOSon1}   AS HANDLE NO-UNDO.
def var h-boin274             as handle no-undo.
def var h-bocx225       as handle no-undo.
def var h-boin172       as handle no-undo.
def var h-boin082       as handle no-undo.
DEF VAR h-boun005       AS HANDLE NO-UNDO.

def var iQuantidade     as integer no-undo.
def var cItem           as char    no-undo.
def var rowsreturn      as integer no-undo.
def var c-return        as char    no-undo.
def var c-desc-item     as char    no-undo.
def var c-descricao-1   as char    no-undo.
def var c-descricao-2   as char    no-undo.
def var de-preco-unit   like cotacao-item.preco-unit no-undo.
def var c-un-nosso      like item.un         no-undo.
def var c-un-fornec     like cotacao-item.un no-undo.
def var de-pre-unit-for like cotacao-item.pre-unit-for no-undo.
def var de-aliquota-ipi like cotacao-item.aliquota-ipi no-undo.
DEF VAR i-mo-codigo     LIKE cotacao-item.mo-codigo    NO-UNDO.
DEF VAR c-desc-moeda    AS CHAR   NO-UNDO.

{cdp/cdcfgmat.i} /* Definicao de pre-processadores - Magnus ou EMS */

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
&Scoped-define INTERNAL-TABLES tt-ordens

/* Definitions for BROWSE brSon1                                        */
&Scoped-define FIELDS-IN-QUERY-brSon1 tt-ordens.it-codigo tt-ordens.desc-item tt-ordens.quantidade fnUnItem() @ c-un-nosso tt-ordens.qt-do-forn fnUnFornec() @ c-un-fornec fnMoeda() @ i-mo-codigo fnDescMoeda() @ c-desc-moeda tt-ordens.valor   
&Scoped-define ENABLED-FIELDS-IN-QUERY-brSon1   
&Scoped-define SELF-NAME brSon1
&Scoped-define OPEN-QUERY-brSon1 OPEN QUERY {&SELF-NAME} FOR EACH tt-ordens NO-LOCK.
&Scoped-define TABLES-IN-QUERY-brSon1 tt-ordens
&Scoped-define FIRST-TABLE-IN-QUERY-brSon1 tt-ordens


/* Definitions for FRAME fPage1                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-fPage1 ~
    ~{&OPEN-QUERY-brSon1}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS tt-embarque-imp.cod-estabel ~
tt-embarque-imp.embarque 
&Scoped-define ENABLED-TABLES tt-embarque-imp
&Scoped-define FIRST-ENABLED-TABLE tt-embarque-imp
&Scoped-define DISPLAYED-TABLES tt-embarque-imp
&Scoped-define FIRST-DISPLAYED-TABLE tt-embarque-imp
&Scoped-Define ENABLED-OBJECTS btQueryJoins btReportsJoins btExit btHelp ~
rtParent rtToolBar 
&Scoped-Define DISPLAYED-FIELDS tt-embarque-imp.cod-estabel ~
tt-embarque-imp.embarque 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnDescMoeda wMasterDetail 
FUNCTION fnDescMoeda RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnItem wMasterDetail 
FUNCTION fnItem RETURNS CHARACTER
  (input pnum-ordem as integer)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnMoeda wMasterDetail 
FUNCTION fnMoeda RETURNS INTEGER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnUnFornec wMasterDetail 
FUNCTION fnUnFornec RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnUnItem wMasterDetail 
FUNCTION fnUnItem RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR wMasterDetail AS WIDGET-HANDLE NO-UNDO.

/* Menu Definitions                                                     */
DEFINE SUB-MENU smFile 
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

DEFINE BUTTON btHelp 
     IMAGE-UP FILE "image~\im-hel":U
     IMAGE-INSENSITIVE FILE "image~\ii-hel":U
     LABEL "Help" 
     SIZE 4 BY 1.25
     FONT 4.

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

DEFINE RECTANGLE rtParent
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 90 BY 2.25.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE  
     SIZE 90 BY 1.5
     BGCOLOR 7 .

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY brSon1 FOR 
      tt-ordens SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE brSon1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS brSon1 wMasterDetail _FREEFORM
  QUERY brSon1 DISPLAY
      tt-ordens.it-codigo FORMAT "X(16)" WIDTH 18 column-label "Item"
      tt-ordens.desc-item format "x(36)" column-label "Descri‡Æo"
      tt-ordens.quantidade format ">>>>>,>>9.9999" column-label "Nossa Qtde"
      fnUnItem() @ c-un-nosso format "xx" column-label "Un"
      tt-ordens.qt-do-forn format ">>>>>,>>9.9999" column-label "Qtde Fornec"
      fnUnFornec() @ c-un-fornec format "xx" column-label "Un Fornec"
      fnMoeda() @ i-mo-codigo FORMAT ">9" COLUMN-LABEL "Moeda"
      fnDescMoeda() @ c-desc-moeda FORMAT "X(12)" COLUMN-LABEL "Descri‡Æo"
      tt-ordens.valor format ">>>,>>>,>>>.99999" column-label "Valor Total"
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 85.14 BY 5.96
         FONT 2.


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
     tt-embarque-imp.cod-estabel AT ROW 2.83 COL 35 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 5 BY .88
     tt-embarque-imp.embarque AT ROW 3.83 COL 35 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 17 BY .88
     rtParent AT ROW 2.67 COL 1
     rtToolBar AT ROW 1 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 90 BY 14.04
         FONT 1.

DEFINE FRAME fPage1
     brSon1 AT ROW 1.17 COL 1.86
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 2.43 ROW 6.38
         SIZE 87.14 BY 7.83
         FONT 1.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: MasterDetail
   Allow: Basic,Browse,DB-Fields,Window,Query
   Add Fields to: Neither
   Other Settings: COMPILE
   Temp-Tables and Buffers:
      TABLE: tt-embarque-imp T "?" NO-UNDO mgcex embarque-imp
      ADDITIONAL-FIELDS:
          field r-rowid as rowid
      END-FIELDS.
      TABLE: tt-ordens T "?" NO-UNDO mgcex ordens-embarque
      ADDITIONAL-FIELDS:
          field r-rowid      as rowid
          field valor        as decimal
          field it-codigo    as char
          field data-entrega as date
          field num-pedido   like processo-imp.num-pedido
          field rownum as int
          field desc-item as char
      END-FIELDS.
      TABLE: tt-ordens-aux T "?" NO-UNDO mgcex ordens-embarque
      ADDITIONAL-FIELDS:
          field r-rowid      as rowid
          field valor        as decimal
          field desc-item    as char
          field it-codigo    as char
          field data-entrega as date
          field num-pedido   like processo-imp.num-pedido
          field rownum as int
      END-FIELDS.
      TABLE: tt-ordens-embarque T "?" NO-UNDO mgcex ordens-embarque
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
         HEIGHT             = 14.08
         WIDTH              = 89.86
         MAX-HEIGHT         = 21.21
         MAX-WIDTH          = 114.29
         VIRTUAL-HEIGHT     = 21.21
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
ASSIGN FRAME fPage1:FRAME = FRAME fPage0:HANDLE.

/* SETTINGS FOR FRAME fPage0
   FRAME-NAME                                                           */
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
     _START_FREEFORM
OPEN QUERY {&SELF-NAME} FOR EACH tt-ordens NO-LOCK.
     _END_FREEFORM
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


&Scoped-define BROWSE-NAME brSon1
&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wMasterDetail 


/* ***************************  Main Block  *************************** */

/*--- L¢gica para inicializa‡Æo do programam ---*/
    {masterdetail/mainblock.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterDestroyinterface wMasterDetail 
PROCEDURE afterDestroyinterface :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    if valid-handle(h-bocx225) then
        delete procedure h-bocx225.
    if valid-handle(h-boin274) then
        delete procedure h-boin274.
    if valid-handle(h-boin082) then
        delete procedure h-boin082.
    if valid-handle(h-boin172) then
        delete procedure h-boin172.

    assign h-bocx225 = ?
           h-boin274  = ?
           h-boin082  = ?
           h-boin172  = ?.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterDisplayfields wMasterDetail 
PROCEDURE afterDisplayfields :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    assign tt-embarque-imp.cod-estabel:screen-value in frame fPage0 = pcod-estabel
           tt-embarque-imp.embarque:screen-value    in frame fPage0 = pembarque.

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
    IF NOT VALID-HANDLE({&hDBOParent}) THEN DO:
       RUN cxbo/bocx220.p persistent set h-bocx220.
    END.
    
    &IF DEFINED(DBOVersion) <> 0 &THEN
        RUN openQuery IN {&hDBOParent} (INPUT 2).
    &ELSE
        RUN openQueryStatic IN {&hDBOParent} (INPUT "cod-estabel":U).
    &ENDIF
      
    /*--- Verifica se o DBO j  est  inicializado ---*/
    IF NOT VALID-HANDLE({&hDBOSon1}) THEN DO:
       RUN cxbo/bocx225d.p persistent set h-bocx225d.
    END.
    
    RUN cxbo/bocx225.p persistent set h-bocx225.
    RUN inbo/boin274.p persistent set h-boin274.    
    run inbo/boin172.p persistent set h-boin172.
    run inbo/boin082.p persistent set h-boin082.
    RUN unbo/boun005.p PERSISTENT SET h-boun005.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueriesSon wMasterDetail 
PROCEDURE openQueriesSon :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    RUN setConstraint2 in h-bocx225d (input pembarque,
                                      input pcod-estabel,
                                      input 2).
                                      
    RUN openQuery in h-bocx225d (input 1).             
    RUN retornaTTOrdens in h-bocx225d (output table TT-Ordens).
    
/*     for each tt-ordens:                                                             */
/*                                                                                     */
/*         run findCodigo in h-boin172 (input tt-ordens.it-codigo, output c-return).   */
/*                                                                                     */
/*         &if defined(bf-mat-comex) &then                                             */
/*            if c-return = "" then do:                                                */
/*                run getcharfield in h-boin172 ("descricao-1", output c-descricao-1). */
/*                run getcharfield in h-boin172 ("descricao-2", output c-descricao-2). */
/*                assign c-desc-item = c-descricao-1 + c-descricao-2.                  */
/*            end.                                                                     */
/*         &else                                                                       */
/*            if c-return = "" then                                                    */
/*               run getcharfield in h-boin172 ("desc-item", output c-desc-item).      */
/*         &endif                                                                      */
/*                                                                                     */
/*         create tt-ordens-aux.                                                       */
/*         buffer-copy tt-ordens to tt-ordens-aux.                                     */
/*         assign tt-ordens-aux.desc-item = c-desc-item.                               */
/*                                                                                     */
/*     end.                                                                            */
    
    
    {&OPEN-QUERY-brSon1}
    APPLY "VALUE-CHANGED":U TO BROWSE brSon1.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fnDescMoeda wMasterDetail 
FUNCTION fnDescMoeda RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

    RUN findCodigo IN h-boun005 (INPUT i-mo-codigo,
                                 OUTPUT c-return).
    IF c-return = "" THEN
       RUN getCharField IN h-boun005 (INPUT "descricao":U,
                                      OUTPUT c-desc-moeda).

  RETURN c-desc-moeda.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fnItem wMasterDetail 
FUNCTION fnItem RETURNS CHARACTER
  (input pnum-ordem as integer) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  def var c-descricao as char no-undo.
  def var cStatus as char no-undo.
  RUN findOrdem in h-boin274 (input pnum-ordem, output cStatus).
  
  RUN getCharField in h-boin274 (input "it-codigo", output c-descricao).

  RETURN c-descricao.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fnMoeda wMasterDetail 
FUNCTION fnMoeda RETURNS INTEGER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

    RUN findCotacaoAprovada IN h-boin082 (INPUT tt-ordens.numero-ordem,
                                          OUTPUT c-return).
    IF c-return = "" THEN
        RUN getIntField IN h-boin082 (INPUT "mo-codigo":U,
                                      OUTPUT i-mo-codigo).

  RETURN i-mo-codigo.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fnUnFornec wMasterDetail 
FUNCTION fnUnFornec RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

  run findCotacaoAprovada in h-boin082 (input tt-ordens.numero-ordem,
                                        output c-return).
  if c-return = "" then do:
    run getCharfield in h-boin082(input "un":U,output c-return).
    return c-return.
  end.
  
  return "".

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fnUnItem wMasterDetail 
FUNCTION fnUnItem RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

  run findCodigo in h-boin172 (input tt-ordens.it-codigo, output c-return).

  if c-return = "" then do:
      run getCharField in h-boin172 (input "un", output c-return).
      return c-return.
  end.

  RETURN "".   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

