&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
*/
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
{include/i-prgvrs.i IM3001A 2.00.00.003 } /*** "010003" ***/
/*:T*******************************************************************************
** Copyright DATASUL S.A. (1999)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
&ENDIF

CREATE WIDGET-POOL.

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program        IM3001A
&GLOBAL-DEFINE Version        2.00.00.000

&GLOBAL-DEFINE WindowType     Detail

&GLOBAL-DEFINE Folder         YES
&GLOBAL-DEFINE InitialPage    1
&GLOBAL-DEFINE FolderLabels   Duplicatas

&GLOBAL-DEFINE page0Widgets   btQueryJoins btReportsJoins btExit btHelp
&GLOBAL-DEFINE page1Widgets   bt-atualiza brDuplic

/* Parameters Definitions ---                                           */
DEF INPUT PARAM p-cod-emitente AS INT  NO-UNDO.
DEF INPUT PARAM p-nat-operacao AS CHAR NO-UNDO.
DEF INPUT PARAM p-serie-docto  AS CHAR NO-UNDO.
DEF INPUT PARAM p-nro-docto    AS CHAR NO-UNDO.
DEF INPUT PARAM p-nff          AS LOGI NO-UNDO.

/* Local Variable Definitions ---                                       */

DEF VAR l-re1701 AS LOG NO-UNDO.
DEF VAR i-cont   AS INT NO-UNDO.

DEF TEMP-TABLE dupli-import NO-UNDO
    FIELD tipo           AS CHAR
    FIELD cod-fornecedor AS INTE FORMAT '>>>>>>>>9'
    FIELD cod-parcela    AS CHAR FORMAT 'x(2)'
    FIELD cod-especie    AS CHAR FORMAT '!!'
    FIELD cod-moeda      AS INTE FORMAT '>9'
    FIELD de-valor-me    AS DECI FORMAT '>>>>>,>>>,>>9.99'
    FIELD de-valor-mo    AS DECI FORMAT '>>>>>,>>>,>>9.99'
    FIELD de-valor-mn    AS DECI FORMAT '>>>>>,>>>,>>9.99'
    FIELD dt-emissao     AS DATE FORMAT '99/99/9999'
    FIELD dt-vencto      AS DATE FORMAT '99/99/9999'
    FIELD tp-despesa     AS INT
    INDEX di-ix AS PRIMARY
          tipo DESCENDING.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fpage0
&Scoped-define BROWSE-NAME brDuplic

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES dupli-import

/* Definitions for BROWSE brDuplic                                      */
&Scoped-define FIELDS-IN-QUERY-brDuplic dupli-import.tipo dupli-import.cod-fornecedor dupli-import.cod-parcela dupli-import.cod-especie dupli-import.de-valor-me dupli-import.cod-moeda dupli-import.de-valor-mo dupli-import.de-valor-mn dupli-import.dt-emissao dupli-import.dt-vencto dupli-import.tp-despesa   
&Scoped-define ENABLED-FIELDS-IN-QUERY-brDuplic   
&Scoped-define SELF-NAME brDuplic
&Scoped-define QUERY-STRING-brDuplic FOR EACH dupli-import NO-LOCK BY dupli-import.tipo DESCENDING
&Scoped-define OPEN-QUERY-brDuplic OPEN QUERY {&SELF-NAME} FOR EACH dupli-import NO-LOCK BY dupli-import.tipo DESCENDING.
&Scoped-define TABLES-IN-QUERY-brDuplic dupli-import
&Scoped-define FIRST-TABLE-IN-QUERY-brDuplic dupli-import


/* Definitions for FRAME fPage1                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-fPage1 ~
    ~{&OPEN-QUERY-brDuplic}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS rtToolBar-2 RECT-3 btQueryJoins ~
btReportsJoins btExit btHelp i-cod-emitente c-nat-operacao c-serie-docto ~
c-nro-docto l-nff 
&Scoped-Define DISPLAYED-OBJECTS i-cod-emitente c-nat-operacao ~
c-serie-docto c-nro-docto l-nff 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
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

DEFINE VARIABLE c-nat-operacao AS CHARACTER FORMAT "x(06)" 
     LABEL "Nat Opera‡Æo":R15 
     VIEW-AS FILL-IN 
     SIZE 5.43 BY .88.

DEFINE VARIABLE c-nro-docto AS CHARACTER FORMAT "x(16)" 
     LABEL "Documento":R11 
     VIEW-AS FILL-IN 
     SIZE 12.57 BY .88.

DEFINE VARIABLE c-serie-docto AS CHARACTER FORMAT "x(5)" 
     LABEL "S‚rie":R7 
     VIEW-AS FILL-IN 
     SIZE 4.72 BY .88.

DEFINE VARIABLE i-cod-emitente AS INTEGER FORMAT ">>>>>>>>9" INITIAL 0 
     LABEL "Emitente":R10 
     VIEW-AS FILL-IN 
     SIZE 7.57 BY .88.

DEFINE RECTANGLE RECT-3
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 88 BY 4.5.

DEFINE RECTANGLE rtToolBar-2
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 90 BY 1.5
     BGCOLOR 7 .

DEFINE VARIABLE l-nff AS LOGICAL INITIAL no 
     LABEL "Nota Fiscal Fatura" 
     VIEW-AS TOGGLE-BOX
     SIZE 16.57 BY .83 NO-UNDO.

DEFINE BUTTON bt-atualiza 
     LABEL "Atualiza" 
     SIZE 11 BY 1.

DEFINE VARIABLE de-tot-docto AS DECIMAL FORMAT ">>>>>,>>>,>>9.99":U INITIAL 0 
     LABEL "Total Documento MN" 
     VIEW-AS FILL-IN 
     SIZE 12 BY .88 NO-UNDO.

DEFINE VARIABLE de-tot-duplicata AS DECIMAL FORMAT ">>>>>,>>>,>>9.99":U INITIAL 0 
     LABEL "Total Duplicatas ME" 
     VIEW-AS FILL-IN 
     SIZE 12 BY .88 NO-UNDO.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY brDuplic FOR 
      dupli-import SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE brDuplic
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS brDuplic wWindow _FREEFORM
  QUERY brDuplic DISPLAY
      dupli-import.tipo
dupli-import.cod-fornecedor
dupli-import.cod-parcela
dupli-import.cod-especie
dupli-import.de-valor-me
dupli-import.cod-moeda
dupli-import.de-valor-mo
dupli-import.de-valor-mn
dupli-import.dt-emissao
dupli-import.dt-vencto
dupli-import.tp-despesa
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 83 BY 7.5
         FONT 1.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fpage0
     btQueryJoins AT ROW 1.13 COL 74.72 HELP
          "Consultas relacionadas"
     btReportsJoins AT ROW 1.13 COL 78.72 HELP
          "Relat¢rios relacionados"
     btExit AT ROW 1.13 COL 82.72 HELP
          "Sair"
     btHelp AT ROW 1.13 COL 86.72 HELP
          "Ajuda"
     i-cod-emitente AT ROW 3 COL 28.57 COLON-ALIGNED
     c-nat-operacao AT ROW 4 COL 28.57 COLON-ALIGNED
     c-serie-docto AT ROW 5 COL 28.57 COLON-ALIGNED
     c-nro-docto AT ROW 6 COL 28.57 COLON-ALIGNED
     l-nff AT ROW 6.25 COL 71.86
     rtToolBar-2 AT ROW 1 COL 1
     RECT-3 AT ROW 2.75 COL 2
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 90 BY 19.21
         FONT 1.

DEFINE FRAME fPage1
     brDuplic AT ROW 1.25 COL 2
     bt-atualiza AT ROW 8.96 COL 2
     de-tot-duplicata AT ROW 9.08 COL 43.14 COLON-ALIGNED
     de-tot-docto AT ROW 9.08 COL 71.14 COLON-ALIGNED
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.57 ROW 8.83
         SIZE 84.43 BY 9.17
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
         TITLE              = ""
         HEIGHT             = 19.25
         WIDTH              = 90
         MAX-HEIGHT         = 22.46
         MAX-WIDTH          = 90
         VIRTUAL-HEIGHT     = 22.46
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
/* BROWSE-TAB brDuplic 1 fPage1 */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wWindow)
THEN wWindow:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE brDuplic
/* Query rebuild information for BROWSE brDuplic
     _START_FREEFORM
OPEN QUERY {&SELF-NAME} FOR EACH dupli-import NO-LOCK BY dupli-import.tipo DESCENDING.
     _END_FREEFORM
     _Query            is OPENED
*/  /* BROWSE brDuplic */
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


&Scoped-define FRAME-NAME fPage1
&Scoped-define SELF-NAME bt-atualiza
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-atualiza wWindow
ON CHOOSE OF bt-atualiza IN FRAME fPage1 /* Atualiza */
DO:
    RUN imp/im3001a1.p (INPUT p-cod-emitente,
                        INPUT p-nat-operacao,
                        INPUT p-serie-docto,
                        INPUT p-nro-docto).
    
    RUN pi-gera-tt-dupli.
    
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fpage0
&Scoped-define SELF-NAME btExit
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btExit wWindow
ON CHOOSE OF btExit IN FRAME fpage0 /* Exit */
OR CHOOSE OF MENU-ITEM miExit IN MENU mbMain DO:
    APPLY "CLOSE":U TO THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btHelp
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btHelp wWindow
ON CHOOSE OF btHelp IN FRAME fpage0 /* Help */
OR CHOOSE OF MENU-ITEM miContents IN MENU mbMain DO:
    {include/ajuda.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btQueryJoins
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btQueryJoins wWindow
ON CHOOSE OF btQueryJoins IN FRAME fpage0 /* Query Joins */
OR CHOOSE OF MENU-ITEM miQueryJoins IN MENU mbMain DO:
    RUN showQueryJoins IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btReportsJoins
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btReportsJoins wWindow
ON CHOOSE OF btReportsJoins IN FRAME fpage0 /* Reports Joins */
OR CHOOSE OF MENU-ITEM miReportsJoins IN MENU mbMain DO:
    RUN showReportsJoins IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME brDuplic
&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wWindow 


/*:T--- L¢gica para inicializa‡Æo do programam ---*/
{window/mainblock.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterInitializeInterface wWindow 
PROCEDURE afterInitializeInterface :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

ASSIGN i-cod-emitente:SCREEN-VALUE IN FRAME fPage0 = STRING(p-cod-emitente)
       c-nat-operacao:SCREEN-VALUE IN FRAME fPage0 = p-nat-operacao
       c-serie-docto :SCREEN-VALUE IN FRAME fPage0 = p-serie-docto
       c-nro-docto   :SCREEN-VALUE IN FRAME fPage0 = p-nro-docto
       l-nff         :CHECKED      IN FRAME fPage0 = p-nff.

RUN utp/ut-liter.p (INPUT "Tipo", INPUT "*", INPUT "R") NO-ERROR.
ASSIGN dupli-import.tipo:LABEL IN BROWSE brDuplic = RETURN-VALUE.
RUN utp/ut-liter.p (INPUT "Fornecedor", INPUT "*", INPUT "R") NO-ERROR.
ASSIGN dupli-import.cod-fornecedor:LABEL IN BROWSE brDuplic = RETURN-VALUE.
RUN utp/ut-liter.p (INPUT "Parcela", INPUT "*", INPUT "R") NO-ERROR.
ASSIGN dupli-import.cod-parcela:LABEL IN BROWSE brDuplic = RETURN-VALUE.
RUN utp/ut-liter.p (INPUT "Esp‚cie", INPUT "*", INPUT "R") NO-ERROR.
ASSIGN dupli-import.cod-especie:LABEL IN BROWSE brDuplic = RETURN-VALUE.
RUN utp/ut-liter.p (INPUT "Moeda", INPUT "*", INPUT "R") NO-ERROR.
ASSIGN dupli-import.cod-moeda:LABEL IN BROWSE brDuplic = RETURN-VALUE.
RUN utp/ut-liter.p (INPUT "Valor_ME", INPUT "*", INPUT "R") NO-ERROR.
ASSIGN dupli-import.de-valor-me:LABEL IN BROWSE brDuplic = RETURN-VALUE.
RUN utp/ut-liter.p (INPUT "Valor_MO", INPUT "*", INPUT "R") NO-ERROR.
ASSIGN dupli-import.de-valor-mo:LABEL IN BROWSE brDuplic = RETURN-VALUE.
RUN utp/ut-liter.p (INPUT "Valor_MN", INPUT "*", INPUT "R") NO-ERROR.
ASSIGN dupli-import.de-valor-mn:LABEL IN BROWSE brDuplic = RETURN-VALUE.
RUN utp/ut-liter.p (INPUT "Dt_EmissÆo", INPUT "*", INPUT "R") NO-ERROR.
ASSIGN dupli-import.dt-emissao:LABEL IN BROWSE brDuplic = RETURN-VALUE.
RUN utp/ut-liter.p (INPUT "Dt_Vencimento", INPUT "*", INPUT "R") NO-ERROR.
ASSIGN dupli-import.dt-vencto:LABEL IN BROWSE brDuplic = RETURN-VALUE.
RUN utp/ut-liter.p (INPUT "Tipo_Despesa", INPUT "*", INPUT "R") NO-ERROR.
ASSIGN dupli-import.tp-despesa:LABEL IN BROWSE brDuplic = RETURN-VALUE.

ENABLE brDuplic WITH FRAME fPage1.

ASSIGN l-re1701 = NO.

IF  i-pais-impto-usuario <> 1  /** Brasil **/ THEN
    ASSIGN bt-atualiza:HIDDEN IN FRAME fPage1 = YES.

RUN pi-gera-tt-dupli.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-gera-tt-dupli wWindow 
PROCEDURE pi-gera-tt-dupli :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    RUN piCriattDupliImport.
    
    ASSIGN de-tot-duplicata = 0
           de-tot-docto     = 0.
    
    FOR EACH dupli-import NO-LOCK:
        ASSIGN de-tot-duplicata = de-tot-duplicata + dupli-import.de-valor-me
               de-tot-docto     = de-tot-docto     + dupli-import.de-valor-mn.
    END.
    
    DISP de-tot-duplicata de-tot-docto WITH FRAME fPage1.
    
    {&OPEN-QUERY-brDuplic}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piCriattDupliImport wWindow 
PROCEDURE piCriattDupliImport :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    
    EMPTY TEMP-TABLE dupli-import.

    DEFINE VARIABLE l-rateio AS LOGICAL NO-UNDO.
    
    FOR EACH  dupli-apagar NO-LOCK
        WHERE dupli-apagar.cod-emitente = p-cod-emitente
          AND dupli-apagar.nat-operacao = p-nat-operacao
          AND dupli-apagar.serie-docto  = p-serie-docto
          AND dupli-apagar.nro-docto    = p-nro-docto:

        FOR FIRST natur-oper FIELDS (nota-rateio)
            WHERE natur-oper.nat-operacao = dupli-apagar.nat-operacao NO-LOCK:

            ASSIGN l-rateio = natur-oper.nota-rateio.
        END.

        IF l-rateio THEN DO:
            {utp/ut-liter.i Despesa * R}
        END.
        ELSE DO:
            {utp/ut-liter.i Material * R}
        END.
            
        CREATE dupli-import.
        ASSIGN dupli-import.tipo           = TRIM(RETURN-VALUE)
               dupli-import.cod-fornecedor = dupli-apagar.cod-emitente
               dupli-import.cod-parcela    = dupli-apagar.parcela
               dupli-import.cod-especie    = dupli-apagar.cod-esp
               dupli-import.cod-moeda      = dupli-apagar.mo-codigo
               dupli-import.de-valor-me    = dupli-apagar.Valor-a-pagar-me
               dupli-import.de-valor-mo    = dupli-apagar.vl-a-pagar-mo
               dupli-import.de-valor-mn    = dupli-apagar.vl-a-pagar
               dupli-import.dt-emissao     = dupli-apagar.dt-emissao
               dupli-import.dt-vencto      = dupli-apagar.dt-vencim
               dupli-import.tp-despesa     = dupli-apagar.tp-despesa.
    END.
    
    {utp/ut-liter.i Despesa * R}

    FOR EACH  dupli-apagar-cex NO-LOCK
        WHERE dupli-apagar-cex.cod-emitente = p-cod-emitente
          AND dupli-apagar-cex.nat-operacao = p-nat-operacao
          AND dupli-apagar-cex.serie-docto  = p-serie-docto
          AND dupli-apagar-cex.nro-docto    = p-nro-docto:
        
        CREATE dupli-import.
        ASSIGN dupli-import.tipo           = TRIM(RETURN-VALUE)
               dupli-import.cod-fornecedor = dupli-apagar-cex.cod-emitente-desp
               dupli-import.cod-parcela    = dupli-apagar-cex.parcela
               dupli-import.cod-especie    = dupli-apagar-cex.cod-esp
               dupli-import.cod-moeda      = dupli-apagar-cex.mo-codigo
               dupli-import.de-valor-me    = dupli-apagar-cex.valor-a-pagar-me
               dupli-import.de-valor-mo    = dupli-apagar-cex.vl-a-pagar-mo
               dupli-import.de-valor-mn    = dupli-apagar-cex.vl-a-pagar
               dupli-import.dt-emissao     = dupli-apagar-cex.dt-emissao
               dupli-import.dt-vencto      = dupli-apagar-cex.dt-vencim
               dupli-import.tp-despesa     = dupli-apagar-cex.tp-despesa.
    END.
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

