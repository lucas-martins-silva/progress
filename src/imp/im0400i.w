&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
*/
&Scoped-define WINDOW-NAME wMaintenanceNoNavigation


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE tt-decla-import NO-UNDO LIKE decla-import
       FIELD r-Rowid AS ROWID.



&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS wMaintenanceNoNavigation 
/*:T*******************************************************************************
** Copyright TOTVS S.A. (2009)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da TOTVS, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i IM0400I 2.00.00.012 } /*** "010012" 10/04/2026 11:05:54 ***/

/* Chamada a include do gerenciador de licen‡as. Necessario alterar os parametros */
/*                                                                                */
/* <programa>:  Informar qual o nome do programa.                                 */
/* <m¢dulo>:  Informar qual o m¢dulo a qual o programa pertence.                  */

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i IM0400I MIM}
&ENDIF

CREATE WIDGET-POOL.

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program           IM0400I
&GLOBAL-DEFINE Version        2.00.00.012

&GLOBAL-DEFINE Folder            NO
&GLOBAL-DEFINE InitialPage       1

&GLOBAL-DEFINE FolderLabels      

&GLOBAL-DEFINE ttTable           tt-decla-import
&GLOBAL-DEFINE hDBOTable         h-bocx383
&GLOBAL-DEFINE DBOTable          decla-import

&GLOBAL-DEFINE page0KeyFields    tt-decla-import.num-di-ems tt-decla-import.cod-di-siscomex tt-decla-import.num-seq-retif tt-decla-import.cod-estab
&GLOBAL-DEFINE page0Fields       
&GLOBAL-DEFINE page0ParentFields 
&GLOBAL-DEFINE page1Fields       
&GLOBAL-DEFINE page2Fields       

/* Parameters Definitions ---                                           */
DEFINE INPUT PARAMETER prTable         AS ROWID     NO-UNDO.
DEFINE INPUT PARAMETER pcAction        AS CHARACTER NO-UNDO.
DEFINE INPUT PARAMETER phCaller        AS HANDLE    NO-UNDO.
/* Local Variable Definitions ---                                       */

DEFINE VARIABLE c-embarque AS CHARACTER FORMAT "x(20)" NO-UNDO.

/* Local Variable Definitions (DBOs Handles) --- */
DEFINE VARIABLE {&hDBOTable}  AS HANDLE NO-UNDO.
DEFINE VARIABLE h-bocx220     AS HANDLE NO-UNDO.

DEFINE TEMP-TABLE tt-docum-est NO-UNDO
    field embarque                   LIKE docum-est.embarque      
    field cod-estabel                LIKE docum-est.cod-estabel   
    field nro-docto                  LIKE docum-est.nro-docto
    field serie-docto                LIKE docum-est.serie-docto   
    field cod-emitente               LIKE docum-est.cod-emitente
    field nat-operacao               LIKE docum-est.nat-operacao
    field idi-nf-simples-remes       LIKE docum-est.idi-nf-simples-remes
    field dt-emissao                 LIKE docum-est.dt-emissao
    field usuario                    LIKE docum-est.usuario                          
    field ce-atual                   LIKE docum-est.ce-atual	
    field embarque-ori               LIKE docum-est.embarque
    field cod-tipo-nf-cred-deb       LIKE docum-est.cod-tipo-nf-cred-deb
    field cod-finalidade             LIKE docum-est.cod-finalidade
    field char-1                     LIKE docum-est.char-1
    FIELD observacao                 AS CHAR
    field r-rowid as rowid
.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE MaintenanceNoNavigation
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fpage0
&Scoped-define BROWSE-NAME brDocRelac

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES tt-docum-est

/* Definitions for BROWSE brDocRelac                                    */
&Scoped-define FIELDS-IN-QUERY-brDocRelac tt-docum-est.cod-estabel tt-docum-est.serie-docto tt-docum-est.cod-emitente tt-docum-est.nat-operacao tt-docum-est.nro-docto fnEmbarque(tt-docum-est.nat-operacao) @ c-embarque fnEmbarqueOrigem(tt-docum-est.cod-estabel, SUBSTRING(tt-docum-est.char-1,1,20)) tt-docum-est.ce-atual fnTipoDocumento(tt-docum-est.idi-nf-simples-remes , tt-docum-est.nat-operacao, tt-docum-est.cod-tipo-nf-cred-deb, tt-docum-est.cod-finalidade) tt-docum-est.observacao
&Scoped-define ENABLED-FIELDS-IN-QUERY-brDocRelac   
&Scoped-define SELF-NAME brDocRelac
&Scoped-define QUERY-STRING-brDocRelac FOR EACH tt-docum-est NO-LOCK
&Scoped-define OPEN-QUERY-brDocRelac OPEN QUERY {&SELF-NAME} FOR EACH tt-docum-est NO-LOCK.
&Scoped-define TABLES-IN-QUERY-brDocRelac tt-docum-est
&Scoped-define FIRST-TABLE-IN-QUERY-brDocRelac tt-docum-est


/* Definitions for FRAME fpage0                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-fpage0 ~
    ~{&OPEN-QUERY-brDocRelac}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS tt-decla-import.num-di-ems ~
tt-decla-import.cod-di-siscomex tt-decla-import.cod-estab ~
tt-decla-import.num-seq-retif 
&Scoped-define ENABLED-TABLES tt-decla-import
&Scoped-define FIRST-ENABLED-TABLE tt-decla-import
&Scoped-Define ENABLED-OBJECTS rtKeys rtToolBar rtKeys-2 RECT-87 brDocRelac ~
btOK btSave btCancel btHelp 
&Scoped-Define DISPLAYED-FIELDS tt-decla-import.num-di-ems ~
tt-decla-import.cod-di-siscomex tt-decla-import.cod-estab ~
tt-decla-import.num-seq-retif 
&Scoped-define DISPLAYED-TABLES tt-decla-import
&Scoped-define FIRST-DISPLAYED-TABLE tt-decla-import


/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnEmbarque wMaintenanceNoNavigation 
FUNCTION fnEmbarque RETURNS CHARACTER
  (pNatOperac   AS CHAR)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnEmbarqueOrigem wMaintenanceNoNavigation 
FUNCTION fnEmbarqueOrigem RETURNS CHARACTER
  ( pcod-estabel AS CHAR,
    pembarque AS CHAR )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnTipoDocumento wMaintenanceNoNavigation 
FUNCTION fnTipoDocumento RETURNS CHARACTER
  ( pidi-nf-simples-remes  AS INT,
    pnat-operacao AS CHAR,
    pcod-tipo-nf-cred-deb as char,
    pcod-finalidade as char) FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR wMaintenanceNoNavigation AS WIDGET-HANDLE NO-UNDO.

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

DEFINE BUTTON btSave 
     LABEL "Salvar" 
     SIZE 10 BY 1.

DEFINE RECTANGLE RECT-87
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 88 BY 11.21.

DEFINE RECTANGLE rtKeys
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 90 BY 3.

DEFINE RECTANGLE rtKeys-2
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 90 BY 12.25.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 90 BY 1.42
     BGCOLOR 7 .

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY brDocRelac FOR 
      tt-docum-est SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE brDocRelac
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS brDocRelac wMaintenanceNoNavigation _FREEFORM
  QUERY brDocRelac NO-LOCK DISPLAY
      tt-docum-est.cod-estabel FORMAT "x(5)":U
tt-docum-est.serie-docto FORMAT "X(5)"    COLUMN-LABEL "Serie"
tt-docum-est.cod-emitente FORMAT ">>>>>>>>9":U
tt-docum-est.nat-operacao FORMAT "x(06)":U
tt-docum-est.nro-docto FORMAT "x(16)":U
fnEmbarque(tt-docum-est.nat-operacao) @ c-embarque FORMAT "x(20)" COLUMN-LABEL "Embarque"
fnEmbarqueOrigem(tt-docum-est.cod-estabel, SUBSTRING(tt-docum-est.char-1,1,20)) COLUMN-LABEL "Emb Origem" FORMAT "X(20)"
tt-docum-est.ce-atual FORMAT "Sim/NÆo":U COLUMN-LABEL "Atualizado?"
fnTipoDocumento(tt-docum-est.idi-nf-simples-remes , tt-docum-est.nat-operacao, tt-docum-est.cod-tipo-nf-cred-deb, tt-docum-est.cod-finalidade)  COLUMN-LABEL "Tipo Docto" FORMAT "X(22)"
tt-docum-est.observacao FORMAT "x(55)" COLUMN-LABEL "Observa‡Æo"
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 84 BY 10.5
         FONT 1 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fpage0
     tt-decla-import.num-di-ems LABEL "DI/DUIMP EMS" AT ROW 1.5 COL 26.57 COLON-ALIGNED WIDGET-ID 12
          VIEW-AS FILL-IN 
          SIZE 10 BY .88
     tt-decla-import.cod-di-siscomex LABEL "DI/DUIMP Siscomex" AT ROW 1.5 COL 58 COLON-ALIGNED WIDGET-ID 8
          VIEW-AS FILL-IN 
          SIZE 10.43 BY .88
     tt-decla-import.cod-estab AT ROW 2.5 COL 26.57 COLON-ALIGNED WIDGET-ID 10
          VIEW-AS FILL-IN 
          SIZE 5 BY .88
     tt-decla-import.num-seq-retif AT ROW 2.5 COL 58 COLON-ALIGNED WIDGET-ID 14
          VIEW-AS FILL-IN 
          SIZE 5 BY .88
     brDocRelac AT ROW 5 COL 4.14 WIDGET-ID 200
     btOK AT ROW 16.63 COL 2
     btSave AT ROW 16.63 COL 13
     btCancel AT ROW 16.63 COL 24
     btHelp AT ROW 16.63 COL 80
     "Documentos Relacionados" VIEW-AS TEXT
          SIZE 24 BY .54 AT ROW 4.29 COL 6 WIDGET-ID 6
     rtKeys AT ROW 1 COL 1
     rtToolBar AT ROW 16.38 COL 1
     rtKeys-2 AT ROW 4 COL 1 WIDGET-ID 2
     RECT-87 AT ROW 4.54 COL 2.14 WIDGET-ID 4
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 90 BY 17
         FONT 1 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: MaintenanceNoNavigation
   Allow: Basic,Browse,DB-Fields,Window,Query
   Add Fields to: Neither
   Other Settings: COMPILE
   Temp-Tables and Buffers:
      TABLE: tt-decla-import T "?" NO-UNDO mgcex decla-import
      ADDITIONAL-FIELDS:
          FIELD r-Rowid AS ROWID
      END-FIELDS.
      TABLE: tt-docum-est T "?" NO-UNDO movind docum-est
      ADDITIONAL-FIELDS:
          FIELD r-rowid AS ROWID
      END-FIELDS.
   END-TABLES.
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW wMaintenanceNoNavigation ASSIGN
         HIDDEN             = YES
         TITLE              = ""
         HEIGHT             = 17
         WIDTH              = 90
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB wMaintenanceNoNavigation 
/* ************************* Included-Libraries *********************** */

{maintenancenonavigation/maintenancenonavigation.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW wMaintenanceNoNavigation
  NOT-VISIBLE,,RUN-PERSISTENT                                           */
/* SETTINGS FOR FRAME fpage0
   FRAME-NAME                                                           */
/* BROWSE-TAB brDocRelac num-seq-retif fpage0 */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wMaintenanceNoNavigation)
THEN wMaintenanceNoNavigation:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE brDocRelac
/* Query rebuild information for BROWSE brDocRelac
     _START_FREEFORM
OPEN QUERY {&SELF-NAME} FOR EACH tt-docum-est NO-LOCK.
     _END_FREEFORM
     _Options          = "NO-LOCK"
     _Query            is OPENED
*/  /* BROWSE brDocRelac */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME fpage0
/* Query rebuild information for FRAME fpage0
     _Options          = "SHARE-LOCK KEEP-EMPTY"
     _Query            is NOT OPENED
*/  /* FRAME fpage0 */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME wMaintenanceNoNavigation
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wMaintenanceNoNavigation wMaintenanceNoNavigation
ON END-ERROR OF wMaintenanceNoNavigation
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wMaintenanceNoNavigation wMaintenanceNoNavigation
ON WINDOW-CLOSE OF wMaintenanceNoNavigation
DO:
  /* This event will close the window and terminate the procedure.  */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btCancel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btCancel wMaintenanceNoNavigation
ON CHOOSE OF btCancel IN FRAME fpage0 /* Cancelar */
DO:
    APPLY "CLOSE":U TO THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btHelp
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btHelp wMaintenanceNoNavigation
ON CHOOSE OF btHelp IN FRAME fpage0 /* Ajuda */
DO:
    {include/ajuda.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btOK
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btOK wMaintenanceNoNavigation
ON CHOOSE OF btOK IN FRAME fpage0 /* OK */
DO:
    APPLY "CLOSE":U TO THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btSave
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btSave wMaintenanceNoNavigation
ON CHOOSE OF btSave IN FRAME fpage0 /* Salvar */
DO:
    RUN saveRecord IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME brDocRelac
&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wMaintenanceNoNavigation 


/*:T--- L¢gica para inicializa‡Æo do programam ---*/
{maintenancenonavigation/mainblock.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterDestroyInterface wMaintenanceNoNavigation 
PROCEDURE afterDestroyInterface :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    IF VALID-HANDLE(h-bocx220) THEN DO:
        DELETE PROCEDURE h-bocx220.
        ASSIGN h-bocx220 = ?.
    END.
                  
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterInitializeInterface wMaintenanceNoNavigation 
PROCEDURE afterInitializeInterface :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    HIDE btSave   IN FRAME fPage0.
    HIDE btCancel IN FRAME fPage0.

    EMPTY TEMP-TABLE tt-docum-est.

    ENABLE brDocRelac WITH FRAME fPage0.

    RUN pi-busca-doc-relacs IN h-bocx383(INPUT prTable,
                                         OUTPUT TABLE tt-docum-est).

    {&OPEN-QUERY-brDocRelac}

    FIND FIRST decla-import
        WHERE rowid(decla-import) = prTable NO-ERROR.
    IF AVAIL decla-import
    AND decla-import.cdd-siscomex-dts <> 0 THEN
        ASSIGN tt-decla-import.num-seq-retif:VISIBLE IN FRAME fPage0 = NO.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE initializeDBOs wMaintenanceNoNavigation 
PROCEDURE initializeDBOs :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    IF NOT VALID-HANDLE(h-bocx220) THEN
        RUN cxbo/bocx220.p PERSISTENT SET h-bocx220.
                  
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE saveParentFields wMaintenanceNoNavigation 
PROCEDURE saveParentFields :
/*:T------------------------------------------------------------------------------
  Purpose:     Salva valores dos campos da tabela filho ({&ttTable}) com base 
               nos campos da tabela pai ({&ttParent})
  Parameters:  
  Notes:       Este m‚todo somente ‚ executado quando a vari vel pcAction 
               possuir os valores ADD ou COPY
------------------------------------------------------------------------------*/
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fnEmbarque wMaintenanceNoNavigation 
FUNCTION fnEmbarque RETURNS CHARACTER
  (pNatOperac   AS CHAR) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
    DEFINE VARIABLE p-embarque AS CHARACTER FORMAT "x(20)"  NO-UNDO.


    ASSIGN p-embarque = "".

    FOR FIRST natur-oper NO-LOCK
        WHERE natur-oper.nat-operacao = pNatOperac :
        IF natur-oper.nota-rateio THEN
            ASSIGN p-embarque = "".
        ELSE
            ASSIGN p-embarque = SUBSTRING(tt-docum-est.char-1,1,20).

    END.

  RETURN p-embarque.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fnEmbarqueOrigem wMaintenanceNoNavigation 
FUNCTION fnEmbarqueOrigem RETURNS CHARACTER
  ( pcod-estabel AS CHAR,
    pembarque AS CHAR ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
    DEFINE VARIABLE c-embarque-orig AS CHARACTER   NO-UNDO.

    IF NOT VALID-HANDLE(h-bocx220) THEN
        RUN cxbo/bocx220.p PERSISTENT SET h-bocx220.
    
    RUN pi-busca-embarque-origem IN h-bocx220 (INPUT pcod-estabel, 
                                               INPUT pembarque, 
                                               OUTPUT c-embarque-orig).

    RETURN c-embarque-orig.   /* Function return value. */
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fnTipoDocumento wMaintenanceNoNavigation 
FUNCTION fnTipoDocumento RETURNS CHARACTER
  ( pidi-nf-simples-remes  AS INT,
    pnat-operacao AS CHAR,
    pcod-tipo-nf-cred-deb as char,
    pcod-finalidade as char):
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
    IF pidi-nf-simples-remes = 1 THEN DO: /* "nota mÆe" */
        {utp/ut-liter.i "Nota_MÆe"}
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
        
            IF  pcod-tipo-nf-cred-deb = "6" /* Nota de D‚bito */
            AND pcod-finalidade       = "6" /* Pagamento Antecipado */ THEN DO:
               {utp/ut-liter.i "Pagamento_Antecipado"}
            END.
            ELSE DO:        
                {utp/ut-liter.i "Nota_Normal"}
            END.
        END.
    END.

    RETURN RETURN-VALUE.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

