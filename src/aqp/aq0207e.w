&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          mgmov            PROGRESS
*/
&Scoped-define WINDOW-NAME wMaintenanceNoNavigation


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE tt-produt-rural NO-UNDO LIKE produt-rural
       field r-rowid as rowid.
DEFINE TEMP-TABLE tt-quant-fornec-produt NO-UNDO LIKE quant-fornec-produt
       field r-rowid as rowid.



&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS wMaintenanceNoNavigation 
/*:T*******************************************************************************
** Copyright TOTVS S.A. (2009)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da TOTVS, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i AQ0207E 2.00.00.009 } /*** "010009" 03/03/2025 09:11:43  ***/

/* Chamada a include do gerenciador de licen‡as. Necessario alterar os parametros */
/*                                                                                */
/* <programa>:  Informar qual o nome do programa.                                 */
/* <m¢dulo>:  Informar qual o m¢dulo a qual o programa pertence.                  */

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i AQ0207E MAQ}
&ENDIF

CREATE WIDGET-POOL.

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program           AQ0207E 
&GLOBAL-DEFINE Version        2.00.00.009

&GLOBAL-DEFINE Folder            NO
&GLOBAL-DEFINE InitialPage       1

&GLOBAL-DEFINE FolderLabels      Vol. Coleta

&GLOBAL-DEFINE ttTable           tt-quant-fornec-produt
&GLOBAL-DEFINE hDBOTable         h-boin01003
&GLOBAL-DEFINE DBOTable          quant-fornec-produt

&GLOBAL-DEFINE ttParent          tt-produt-rural
&GLOBAL-DEFINE DBOParentTable    h-boin00962

&GLOBAL-DEFINE page0KeyFields    
&GLOBAL-DEFINE page0Fields       
&GLOBAL-DEFINE page0ParentFields tt-produt-rural.cdn-produt-rural
&GLOBAL-DEFINE page1Fields       tt-quant-fornec-produt.dat-inic ~
                                 tt-quant-fornec-produt.dat-fim tt-quant-fornec-produt.qtd-fornec ~
                                 tt-quant-fornec-produt.cod-obs     

/* Parameters Definitions ---                                           */
DEFINE INPUT PARAMETER prTable         AS ROWID     NO-UNDO.
DEFINE INPUT PARAMETER prParent        AS ROWID     NO-UNDO.
DEFINE INPUT PARAMETER pcAction        AS CHARACTER NO-UNDO.
DEFINE INPUT PARAMETER phCaller        AS HANDLE    NO-UNDO.
DEFINE INPUT PARAMETER piSonPageNumber AS INTEGER   NO-UNDO.

/* Local Variable Definitions ---                                       */

/* Local Variable Definitions (DBOs Handles) --- */
DEFINE VARIABLE {&hDBOTable}  AS HANDLE NO-UNDO.
DEFINE VARIABLE h-boin627     AS HANDLE NO-UNDO.
DEFINE VARIABLE h-boin00962   AS HANDLE NO-UNDO.
DEFINE VARIABLE h-boin00983   AS HANDLE NO-UNDO.
DEFINE VARIABLE h-boin287     AS HANDLE NO-UNDO. /* param-estoq */


/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE MaintenanceNoNavigation
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fpage0

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS tt-produt-rural.cdn-produt-rural 
&Scoped-define ENABLED-TABLES tt-produt-rural
&Scoped-define FIRST-ENABLED-TABLE tt-produt-rural
&Scoped-Define ENABLED-OBJECTS rtKeys rtToolBar c-desc-produtor btOK btSave ~
btCancel btHelp 
&Scoped-Define DISPLAYED-FIELDS tt-produt-rural.cdn-produt-rural 
&Scoped-define DISPLAYED-TABLES tt-produt-rural
&Scoped-define FIRST-DISPLAYED-TABLE tt-produt-rural
&Scoped-Define DISPLAYED-OBJECTS c-desc-produtor 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
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

DEFINE VARIABLE c-desc-produtor AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 53.43 BY .88 NO-UNDO.

DEFINE RECTANGLE rtKeys
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 90 BY 2.25.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 90 BY 1.42
     BGCOLOR 7 .

DEFINE VARIABLE cb-item AS CHARACTER FORMAT "X(256)":U 
     LABEL "Item" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     DROP-DOWN-LIST
     SIZE 18 BY 1 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fpage0
     tt-produt-rural.cdn-produt-rural AT ROW 1.75 COL 15 COLON-ALIGNED 
          VIEW-AS FILL-IN 
          SIZE 12 BY .88
     c-desc-produtor AT ROW 1.75 COL 27.57 COLON-ALIGNED NO-LABEL 
     btOK AT ROW 16.63 COL 2
     btSave AT ROW 16.63 COL 13
     btCancel AT ROW 16.63 COL 24
     btHelp AT ROW 16.63 COL 80
     rtKeys AT ROW 1 COL 1
     rtToolBar AT ROW 16.38 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 90 BY 17
         FONT 1 .

DEFINE FRAME fPage1
     cb-item AT ROW 2.21 COL 27.86 COLON-ALIGNED 
     tt-quant-fornec-produt.dat-inic AT ROW 3.21 COL 28 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 10 BY .88
     tt-quant-fornec-produt.dat-fim AT ROW 4.25 COL 28 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 10 BY .88
     tt-quant-fornec-produt.qtd-fornec AT ROW 5.33 COL 28 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 31 BY .88
     tt-quant-fornec-produt.cod-obs AT ROW 6.5 COL 30 NO-LABEL
          VIEW-AS EDITOR SCROLLBAR-VERTICAL
          SIZE 47 BY 4
     "Observa‡Æo:" VIEW-AS TEXT
          SIZE 9 BY .54 AT ROW 6.58 COL 20.86
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.5 ROW 4.7
         SIZE 84.43 BY 10.92
         FONT 1 .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: MaintenanceNoNavigation
   Allow: Basic,Browse,DB-Fields,Window,Query
   Add Fields to: Neither
   Other Settings: COMPILE
   Temp-Tables and Buffers:
      TABLE: tt-produt-rural T "?" NO-UNDO mgind produt-rural
      ADDITIONAL-FIELDS:
          field r-rowid as rowid
      END-FIELDS.
      TABLE: tt-quant-fornec-produt T "?" NO-UNDO mgmov quant-fornec-produt
      ADDITIONAL-FIELDS:
          field r-rowid as rowid
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
/* REPARENT FRAME */
ASSIGN FRAME fPage1:FRAME = FRAME fpage0:HANDLE.

/* SETTINGS FOR FRAME fpage0
   FRAME-NAME                                                           */
/* SETTINGS FOR FRAME fPage1
                                                                        */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wMaintenanceNoNavigation)
THEN wMaintenanceNoNavigation:HIDDEN = yes.

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

  RUN pi-validacao.
  IF RETURN-VALUE = "OK" THEN DO:

    RUN saveRecord IN THIS-PROCEDURE.
    IF RETURN-VALUE = "OK":U THEN
      APPLY "CLOSE":U TO THIS-PROCEDURE.

  END.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btSave
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btSave wMaintenanceNoNavigation
ON CHOOSE OF btSave IN FRAME fpage0 /* Salvar */
DO:
    RUN pi-validacao.
    IF RETURN-VALUE = "OK" THEN
      RUN saveRecord IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tt-produt-rural.cdn-produt-rural
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-produt-rural.cdn-produt-rural wMaintenanceNoNavigation
ON LEAVE OF tt-produt-rural.cdn-produt-rural IN FRAME fpage0 /* Produtor Rural */
DO:
    def var c-nome-emit like emitente.nome-emit no-undo.
    DEF VAR c-return     AS CHAR   NO-UNDO.
    def var h-boad098    AS HANDLE NO-UNDO.
    
    assign input frame {&frame-name} tt-produt-rural.cdn-produt-rural.
    run adbo/boad098.p persistent set h-boad098.        
    run findCodigo in h-boad098(input tt-produt-rural.cdn-produt-rural, output c-return).
    if c-return = "" then do:
        run getCharfield in h-boad098(input "nome-emit", output c-nome-emit).
        assign c-desc-produtor:screen-value = c-nome-emit.
    end.
    delete procedure h-boad098.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


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
    IF VALID-HANDLE(h-boin00962) THEN DO:
      DELETE PROCEDURE h-boin00962.
      ASSIGN h-boin00962 = ?.
    END.

    IF VALID-HANDLE(h-boin00983) THEN DO:
      DELETE PROCEDURE h-boin00983.
      ASSIGN h-boin00983 = ?.
    END.

    IF VALID-HANDLE(h-boin627) THEN DO:
      DELETE PROCEDURE h-boin627.
      ASSIGN h-boin627 = ?.
    END.
    
    IF VALID-HANDLE(h-boin287) THEN DO:
      DELETE PROCEDURE h-boin287.
      ASSIGN h-boin287 = ?.
    END.    
    
    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterDisplayFields wMaintenanceNoNavigation 
PROCEDURE afterDisplayFields :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  DEFINE VARIABLE c-list        AS CHARACTER NO-UNDO.
  DEFINE VARIABLE c-cod-estabel AS CHARACTER NO-UNDO.

  /*item padrÆo do estabelecimento do usu rio*/
  RUN findUsuar_mater IN h-boin627 (INPUT c-seg-usuario, OUTPUT c-cod-estabel).  
  IF c-cod-estabel = "" THEN DO:
    RUN getCharField IN h-boin627 (INPUT 'char-1', OUTPUT c-cod-estabel).    
    ASSIGN c-cod-estabel = SUBSTR(c-cod-estabel,16,5). /* estab usuar */    
    /* se nao encontrar estabelecimento padrao do usuario, busca estabelecimento padrao do estoque */
    IF c-cod-estabel = "" THEN DO:
        RUN openQueryStatic IN h-boin287(INPUT "Main":U).
        RUN getCharField    IN h-boin287(INPUT "estabel-pad":U, OUTPUT c-cod-estabel).        
    END.
  END.
  
  RUN getListItems IN h-boin00983(INPUT c-cod-estabel, OUTPUT c-list).

  IF c-list <> "" AND (cb-item:SCREEN-VALUE IN FRAME fPage1 = "" OR cb-item:SCREEN-VALUE IN FRAME fPage1 = ?)THEN DO:        
      ASSIGN cb-item:LIST-ITEMS IN FRAME fPage1   = c-list
             cb-item:SCREEN-VALUE IN FRAME fPage1 = ENTRY (1,c-list).
  END.

  ASSIGN cb-item:SENSITIVE IN FRAME fPage1 = YES.

  APPLY "LEAVE" TO tt-produt-rural.cdn-produt-rural IN FRAME fPage0.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterEnableFields wMaintenanceNoNavigation 
PROCEDURE afterEnableFields :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  IF pcAction <> "ADD" THEN
     ASSIGN cb-item:SENSITIVE IN FRAME fPage1 = NO.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE initializeDBOs wMaintenanceNoNavigation 
PROCEDURE initializeDBOs :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
---------------------------------------------------------------------------*/

    IF NOT VALID-HANDLE(h-boin627) THEN 
        RUN inbo/boin627.p PERSISTENT SET h-boin627.   

    IF NOT VALID-HANDLE(h-boin287) THEN 
        RUN inbo/boin287.p PERSISTENT SET h-boin287.         
    
    /*:T--- Verifica se o DBO j  est  inicializado ---*/
    IF NOT VALID-HANDLE(h-boin00962) OR
       h-boin00962:TYPE <> "PROCEDURE":U OR
       h-boin00962:FILE-NAME <> "inbo/boin00962.p":U THEN DO:
       {btb/btb008za.i1 inbo/boin00962.p YES}
       {btb/btb008za.i2 inbo/boin00962.p '' h-boin00962} 
    END.
    RUN openQueryStatic IN h-boin00962 (INPUT "Main":U) NO-ERROR.

        /*:T--- Verifica se o DBO ja esta inicializado ---*/
    IF NOT VALID-HANDLE(h-boin00983) OR 
        h-boin00983:TYPE <> "PROCEDURE":U OR
        h-boin00983:FILE-NAME <> "inbo/boin00983.p":U THEN DO:

        {btb/btb008za.i1 inbo/boin00983.p YES}
        {btb/btb008za.i2 inbo/boin00983.p ''  h-boin00983} 
    END.
    RUN openQueryStatic IN h-boin00983 (INPUT "Main":U) NO-ERROR.
    
    /*:T--- Verifica se o DBO j  est  inicializado ---*/
    IF NOT VALID-HANDLE({&hDBOTable}) OR 
       {&hDBOTable}:TYPE <> "PROCEDURE":U OR
       {&hDBOTable}:FILE-NAME <> "inbo/boin01003.p":U THEN DO:
       {btb/btb008za.i1 inbo/boin01003.p YES}
       {btb/btb008za.i2 inbo/boin01003.p '' {&hDBOTable}} 
    END.
    RUN openQueryStatic IN {&hDBOTable} (INPUT "Main":U) NO-ERROR.
    
    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-validacao wMaintenanceNoNavigation 
PROCEDURE pi-validacao :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE dataIni   AS DATE      NO-UNDO.
  DEFINE VARIABLE dataFim   AS DATE      NO-UNDO.
  DEFINE VARIABLE prodRural AS INTEGER   NO-UNDO.
  DEFINE VARIABLE itemAux   AS CHARACTER NO-UNDO.

  ASSIGN prodRural = INPUT FRAME fPage0 tt-produt-rural.cdn-produt-rural.

  ASSIGN dataIni   = INPUT FRAME fPage1 tt-quant-fornec-produt.dat-inic
         dataFim   = INPUT FRAME fPage1 tt-quant-fornec-produt.dat-fim
         itemAux   = INPUT FRAME fPage1 cb-item.

  IF dataIni > dataFim THEN DO:
    RUN utp/ut-msgs.p (INPUT "show",
                       INPUT 198,
                       INPUT "").
    RETURN "NOK".
  END.

  IF dataIni = ?  OR dataFim = ?  THEN DO:
    RUN utp/ut-msgs.p (INPUT "show",
                       INPUT 173,
                       INPUT "").
    RETURN "NOK".
  END.

  RUN goToKey IN h-boin01003(INPUT prodRural,
                             INPUT itemAux,
                             INPUT dataIni,
                             INPUT dataFim).
  IF RETURN-VALUE = "OK":U THEN DO:
    RUN utp/ut-msgs.p (INPUT "SHOW":U, INPUT 25498, INPUT "").
    RETURN "NOK".
  END.

  RETURN "OK".

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

    ASSIGN {&ttTable}.cdn-produt-rural = {&ttParent}.cdn-produt-rural.

    ASSIGN {&ttTable}.it-codigo = INPUT FRAME fPage1 cb-item.
    
    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

