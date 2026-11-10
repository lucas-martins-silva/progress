&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
*/
&Scoped-define WINDOW-NAME wMaintenanceNoNavigation


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE tt-produt-carg NO-UNDO LIKE produt-carg
       FIELD r-rowid AS ROWID.
DEFINE TEMP-TABLE tt-pto-coleta NO-UNDO LIKE pto-coleta
       FIELD r-rowid AS ROWID.



&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS wMaintenanceNoNavigation 
/*:T*******************************************************************************
** Copyright TOTVS S.A. (2009)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da TOTVS, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i AQ0302D 2.00.00.012 } /*** "010012" ***/

/* Chamada a include do gerenciador de licen‡as. Necessario alterar os parametros */
/*                                                                                */
/* <programa>:  Informar qual o nome do programa.                                 */
/* <m¢dulo>:  Informar qual o m¢dulo a qual o programa pertence.                  */

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i AQ0302d MAQ}
&ENDIF

CREATE WIDGET-POOL.

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program           AQ0302d
&GLOBAL-DEFINE Version        2.00.00.012

&GLOBAL-DEFINE Folder            NO
&GLOBAL-DEFINE InitialPage       1

&GLOBAL-DEFINE FolderLabels      

&GLOBAL-DEFINE ttTable           tt-produt-carg
&GLOBAL-DEFINE hDBOTable         h-boin00965
&GLOBAL-DEFINE DBOTable          produt-carg

&GLOBAL-DEFINE ttParent          tt-pto-coleta
&GLOBAL-DEFINE DBOParentTable    pto-coleta

&GLOBAL-DEFINE page0KeyFields    
&GLOBAL-DEFINE page0Fields       
&GLOBAL-DEFINE page0ParentFields tt-pto-coleta.cod-pto-coleta tt-pto-coleta.des-pto-coleta 
                                
                                 
&GLOBAL-DEFINE page1Fields       tt-produt-carg.cdn-produt-rural tt-produt-carg.qtd-coleta
                                 
                                 
   

/* Parameters Definitions ---                                           */
DEFINE INPUT PARAMETER prTable         AS ROWID     NO-UNDO.
DEFINE INPUT PARAMETER prParent        AS ROWID     NO-UNDO.
DEFINE INPUT PARAMETER pcAction        AS CHARACTER NO-UNDO.
DEFINE INPUT PARAMETER phCaller        AS HANDLE    NO-UNDO.
DEFINE INPUT PARAMETER piSonPageNumber AS INTEGER   NO-UNDO.
DEFINE INPUT PARAMETER prCdnIdentif    AS INTEGER   NO-UNDO.

/* Shared Variable Definitions ---                                      */
DEFINE SHARED VARIABLE v_cdn-identif AS INTEGER NO-UNDO.
DEFINE SHARED VARIABLE v_l-fraciona  AS LOGICAL NO-UNDO.


/* Local Variable Definitions ---                                       */

/* Local Variable Definitions (DBOs Handles) --- */
DEFINE VARIABLE {&hDBOTable}    AS HANDLE NO-UNDO.
DEFINE VARIABLE h-boin00966     AS HANDLE NO-UNDO.
DEFINE VARIABLE h-boin00965-2   AS HANDLE NO-UNDO.
DEFINE VARIABLE h-boad098       AS HANDLE NO-UNDO.
DEFINE VARIABLE h-boin00967     AS HANDLE NO-UNDO.
DEFINE VARIABLE h-boin00990     AS HANDLE NO-UNDO.
DEFINE VARIABLE h-boin00961     AS HANDLE NO-UNDO.
DEFINE VARIABLE h-aqapi005      AS HANDLE NO-UNDO.
DEFINE VARIABLE i-cdn-sit       AS INTEGER   NO-UNDO.
DEFINE VARIABLE c-cod-propried  AS CHARACTER NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE MaintenanceNoNavigation
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fpage0

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS tt-pto-coleta.cod-pto-coleta ~
tt-pto-coleta.des-pto-coleta 
&Scoped-define ENABLED-TABLES tt-pto-coleta
&Scoped-define FIRST-ENABLED-TABLE tt-pto-coleta
&Scoped-Define ENABLED-OBJECTS rtKeys rtToolBar btOK btSave btCancel btHelp 
&Scoped-Define DISPLAYED-FIELDS tt-pto-coleta.cod-pto-coleta ~
tt-pto-coleta.des-pto-coleta 
&Scoped-define DISPLAYED-TABLES tt-pto-coleta
&Scoped-define FIRST-DISPLAYED-TABLE tt-pto-coleta


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

DEFINE RECTANGLE rtKeys
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 90 BY 2.25.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 90 BY 1.42
     BGCOLOR 7 .

DEFINE VARIABLE c-nome-emit AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 32 BY .88 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fpage0
     tt-pto-coleta.cod-pto-coleta AT ROW 1.75 COL 12 COLON-ALIGNED WIDGET-ID 4
          VIEW-AS FILL-IN 
          SIZE 12.57 BY .88
     tt-pto-coleta.des-pto-coleta AT ROW 1.75 COL 24.72 COLON-ALIGNED NO-LABEL WIDGET-ID 12
          VIEW-AS FILL-IN 
          SIZE 28 BY .88
     btOK AT ROW 9.29 COL 2
     btSave AT ROW 9.29 COL 13
     btCancel AT ROW 9.29 COL 24
     btHelp AT ROW 9.29 COL 80
     rtKeys AT ROW 1 COL 1
     rtToolBar AT ROW 9.04 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 90 BY 9.63
         FONT 1 WIDGET-ID 100.

DEFINE FRAME fPage1
     tt-produt-carg.cdn-produt-rural AT ROW 1.63 COL 20 COLON-ALIGNED WIDGET-ID 2
          VIEW-AS FILL-IN 
          SIZE 12.57 BY .88
     c-nome-emit AT ROW 1.63 COL 32.72 COLON-ALIGNED NO-LABEL WIDGET-ID 18
     tt-produt-carg.qtd-coleta AT ROW 2.63 COL 20 COLON-ALIGNED WIDGET-ID 8
          VIEW-AS FILL-IN 
          SIZE 18 BY .88
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.57 ROW 4.71
         SIZE 84.43 BY 3.79
         FONT 1 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: MaintenanceNoNavigation
   Allow: Basic,Browse,DB-Fields,Window,Query
   Add Fields to: Neither
   Temp-Tables and Buffers:
      TABLE: tt-produt-carg T "?" NO-UNDO movind produt-carg
      ADDITIONAL-FIELDS:
          FIELD r-rowid AS ROWID
      END-FIELDS.
      TABLE: tt-pto-coleta T "?" NO-UNDO mgind pto-coleta
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
         HEIGHT             = 9.63
         WIDTH              = 90
         MAX-HEIGHT         = 39.46
         MAX-WIDTH          = 182.86
         VIRTUAL-HEIGHT     = 39.46
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
  ASSIGN v_cdn-identif = ?.
  
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btCancel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btCancel wMaintenanceNoNavigation
ON CHOOSE OF btCancel IN FRAME fpage0 /* Cancelar */
DO:
    ASSIGN v_cdn-identif = ?.
    
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

    IF INPUT FRAME fPage1 tt-produt-carg.qtd-coleta = 0 THEN DO:
        {utp/ut-liter.i Quantidade_Coleta }
        RUN utp/ut-msgs.p(INPUT 'SHOW':U,
                          INPUT 36,
                          INPUT RETURN-VALUE).
        APPLY "ENTRY":U TO tt-produt-carg.qtd-coleta IN FRAME fPage1.
        RETURN NO-APPLY. 

    END.

    RUN atualizaCodPropried.
    RUN pi-verifica-inativos.
    IF CAN-FIND(FIRST RowErrors
                WHERE RowErrors.ErrorType <> "INTERNAL":U) THEN DO:            
        {method/showmessage.i1}
        {method/showmessage.i2}
        RETURN NO-APPLY.
    END. 

    RUN saveRecord IN THIS-PROCEDURE.
    IF RETURN-VALUE = "OK":U THEN DO:
        APPLY "CLOSE":U TO THIS-PROCEDURE.
    END.
    ELSE
        ASSIGN v_cdn-identif = ?.    
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btSave
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btSave wMaintenanceNoNavigation
ON CHOOSE OF btSave IN FRAME fpage0 /* Salvar */
DO:
    IF INPUT FRAME fPage1 tt-produt-carg.qtd-coleta = 0 THEN DO:
        {utp/ut-liter.i Quantidade_Coleta }
        RUN utp/ut-msgs.p(INPUT 'SHOW':U,
                          INPUT 36,
                          INPUT RETURN-VALUE).
        APPLY "ENTRY":U TO tt-produt-carg.qtd-coleta IN FRAME fPage1.
        RETURN NO-APPLY. 

    END.

    RUN pi-verifica-inativos.
    IF CAN-FIND(FIRST RowErrors
                WHERE RowErrors.ErrorType <> "INTERNAL":U) THEN DO:            
        {method/showmessage.i1}
        {method/showmessage.i2}
        RETURN NO-APPLY.
    END. 

    RUN saveRecord IN THIS-PROCEDURE.
    IF RETURN-VALUE <> "OK":U THEN 
        ASSIGN v_cdn-identif = ?.       
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage1
&Scoped-define SELF-NAME tt-produt-carg.cdn-produt-rural
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-produt-carg.cdn-produt-rural wMaintenanceNoNavigation
ON LEAVE OF tt-produt-carg.cdn-produt-rural IN FRAME fPage1 /* Produtor Rural */
DO:
    DEFINE VARIABLE pNomeEmit AS CHARACTER NO-UNDO.
    
    RUN canFindProdutPtoColeta IN h-boin00990(INPUT INPUT FRAME fPage1 tt-produt-carg.cdn-produt-rural,  
                                              INPUT {&ttParent}.cod-pto-coleta).

    IF RETURN-VALUE = 'OK' THEN DO:

        RUN findCodigo IN h-boad098(INPUT tt-produt-carg.cdn-produt-rural:SCREEN-VALUE IN FRAME fPage1, 
                                    OUTPUT pNomeEmit).
        IF pNomeEmit = "" THEN DO:        
            RUN goToKey IN h-boad098 (INPUT tt-produt-carg.cdn-produt-rural:SCREEN-VALUE IN FRAME fPage1) NO-ERROR.
            RUN getCharfield IN h-boad098(INPUT "nome-emit", OUTPUT pNomeEmit).
        END.
    END.

    ASSIGN c-nome-emit:SCREEN-VALUE IN FRAME fPage1 = pNomeEmit.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-produt-carg.cdn-produt-rural wMaintenanceNoNavigation
ON MOUSE-SELECT-DBLCLICK OF tt-produt-carg.cdn-produt-rural IN FRAME fPage1 /* Produtor Rural */
OR F5 OF tt-produt-carg.cdn-produt-rural IN FRAME fPage1
DO:
    {method/zoomfields.i &ProgramZoom="inzoom/z01in00990.w"
                         &FieldZoom1="cdn-produt-rural"
                         &FieldScreen1="tt-produt-carg.cdn-produt-rural"
                         &Frame1="fPage1"                          
                         &EnableImplant="YES"
                         &RunMethod="RUN setParams IN hProgramZoom (INPUT tt-pto-coleta.cod-pto-coleta)."}   
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fpage0
&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wMaintenanceNoNavigation 


/*:T--- L¢gica para inicializa‡Æo do programam ---*/
{maintenancenonavigation/mainblock.i}

tt-produt-carg.cdn-produt-rural:LOAD-MOUSE-POINTER("image/lupa.cur":U) IN FRAME fPage1.

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

    IF VALID-HANDLE(h-boin00966) AND
        h-boin00966:TYPE = "PROCEDURE":U AND
        h-boin00966:FILE-NAME = "inbo/boin00966.p":U THEN DO:
        DELETE PROCEDURE h-boin00966.
        ASSIGN h-boin00966 = ?.
    END.

    IF VALID-HANDLE({&hDBOTable}) AND
        {&hDBOTable}:TYPE = "PROCEDURE":U AND
        {&hDBOTable}:FILE-NAME = "inbo/boin00965.p":U THEN DO:
        DELETE PROCEDURE {&hDBOTable}.
        ASSIGN {&hDBOTable} = ?.
    END.

    IF VALID-HANDLE(h-boin00965-2) AND
        h-boin00965-2:TYPE = "PROCEDURE":U AND
        h-boin00965-2:FILE-NAME = "inbo/boin00965.p":U THEN DO:
        DELETE PROCEDURE h-boin00965-2.
        ASSIGN h-boin00965-2 = ?.
    END.

    IF VALID-HANDLE(h-boad098) AND
        h-boad098:TYPE = "PROCEDURE":U AND
        h-boad098:FILE-NAME = "adbo/boad098.p":U THEN DO:
        DELETE PROCEDURE h-boad098.
        ASSIGN h-boad098 = ?.
    END.

    IF VALID-HANDLE(h-boin00967) AND
        h-boin00967:TYPE = "PROCEDURE":U AND
        h-boin00967:FILE-NAME = "inbo/boin00967.p":U THEN DO:
        DELETE PROCEDURE h-boin00967.
        ASSIGN h-boin00967 = ?.
    END.

    IF VALID-HANDLE(h-boin00990) AND
        h-boin00990:TYPE = "PROCEDURE":U AND
        h-boin00990:FILE-NAME = "inbo/boin00990.p":U THEN DO:
        DELETE PROCEDURE h-boin00990.
        ASSIGN h-boin00990 = ?.
    END.

    IF VALID-HANDLE(h-boin00961) AND
        h-boin00961:TYPE = "PROCEDURE":U AND
        h-boin00961:FILE-NAME = "inbo/boin00961.p":U THEN DO:
        DELETE PROCEDURE h-boin00961.
        ASSIGN h-boin00961 = ?.
    END.

    IF VALID-HANDLE(h-aqapi005) AND
        h-aqapi005:TYPE = "PROCEDURE":U AND
        h-aqapi005:FILE-NAME = "aqp/aqapi005.p":U THEN DO:
        DELETE PROCEDURE h-aqapi005.
        ASSIGN h-aqapi005 = ?.
    END.
    
    RETURN 'OK':U.
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
    IF pcAction = "Update":U THEN
        APPLY "LEAVE" TO tt-produt-carg.cdn-produt-rural IN FRAME fPage1.

    IF NOT v_l-fraciona THEN
        ASSIGN tt-produt-carg.qtd-coleta:FORMAT IN FRAME fPage1 = ">>>,>>>,>>9":U.
    RETURN 'OK':U.
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

    IF pcAction = "Update":U THEN
        ASSIGN tt-produt-carg.cdn-produt-rural:SENSITIVE IN FRAME fPage1 = NO.

    RETURN 'OK':U. 
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE beforeDisplayFields wMaintenanceNoNavigation 
PROCEDURE beforeDisplayFields :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    {utp/ut-liter.i Quantidade * R }
    ASSIGN tt-produt-carg.qtd-coleta:LABEL IN FRAME fPage1 = TRIM(RETURN-VALUE).
    
    RETURN 'OK':U.
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

    /*:T--- Verifica se o DBO ja esta inicializado ---*/
    IF NOT VALID-HANDLE(h-boin00966) OR
       h-boin00966:TYPE <> "PROCEDURE":U OR
       h-boin00966:FILE-NAME <> "inbo/boin00966.p":U THEN DO:
        {btb/btb008za.i1 inbo/boin00966.p YES}
        {btb/btb008za.i2 inbo/boin00966.p '' h-boin00966} 
    END.
    
    RUN openQueryStatic IN h-boin00966 (INPUT "Main":U) NO-ERROR.

    /*:T--- Verifica se o DBO ja esta inicializado ---*/
    IF NOT VALID-HANDLE({&hDBOTable}) OR 
       {&hDBOTable}:TYPE <> "PROCEDURE":U OR
       {&hDBOTable}:FILE-NAME <> "inbo/boin00965.p":U THEN DO:

        {btb/btb008za.i1 inbo/boin00965.p YES}
        {btb/btb008za.i2 inbo/boin00965.p '' {&hDBOTable}} 
    END.
    
    RUN openQueryStatic IN {&hDBOTable} (INPUT "Main":U) NO-ERROR.

    /*:T--- Verifica se o DBO ja esta inicializado ---*/
    IF NOT VALID-HANDLE(h-boin00965-2) OR
       h-boin00965-2:TYPE <> "PROCEDURE":U OR
       h-boin00965-2:FILE-NAME <> "inbo/boin00965.p":U THEN DO:
        {btb/btb008za.i1 inbo/boin00965.p YES}
        {btb/btb008za.i2 inbo/boin00965.p '' h-boin00965-2} 
    END.
    
    RUN openQueryStatic IN h-boin00965-2 (INPUT "Main":U) NO-ERROR.

    /*:T--- Verifica se o DBO ja esta inicializado ---*/
    IF NOT VALID-HANDLE(h-boad098) OR 
       h-boad098:TYPE <> "PROCEDURE":U OR
       h-boad098:FILE-NAME <> "adbo/boad098.p":U THEN DO:

        {btb/btb008za.i1 adbo/boad098.p YES}
        {btb/btb008za.i2 adbo/boad098.p '' h-boad098} 
    END.
    
    RUN openQueryStatic IN h-boad098 (INPUT "Main":U) NO-ERROR.

    /*:T--- Verifica se o DBO ja esta inicializado ---*/
    IF NOT VALID-HANDLE(h-boin00967) OR 
       h-boin00967:TYPE <> "PROCEDURE":U OR
       h-boin00967:FILE-NAME <> "inbo/boin00967.p":U THEN DO:

        {btb/btb008za.i1 inbo/boin00967.p YES}
        {btb/btb008za.i2 inbo/boin00967.p '' h-boin00967} 
    END.
    
    RUN openQueryStatic IN h-boin00967 (INPUT "Main":U) NO-ERROR.

    /*:T--- Verifica se o DBO ja esta inicializado ---*/
    IF NOT VALID-HANDLE(h-boin00990) OR 
       h-boin00990:TYPE <> "PROCEDURE":U OR
       h-boin00990:FILE-NAME <> "inbo/boin00990.p":U THEN DO:

        {btb/btb008za.i1 inbo/boin00990.p YES}
        {btb/btb008za.i2 inbo/boin00990.p '' h-boin00990} 
    END.
    
    RUN openQueryStatic IN h-boin00990 (INPUT "Main":U) NO-ERROR.

    /*:T--- Verifica se o DBO ja esta inicializado ---*/
    IF NOT VALID-HANDLE(h-boin00961) OR 
       h-boin00961:TYPE <> "PROCEDURE":U OR
       h-boin00961:FILE-NAME <> "inbo/boin00961.p":U THEN DO:

        {btb/btb008za.i1 inbo/boin00961.p YES}
        {btb/btb008za.i2 inbo/boin00961.p '' h-boin00961} 
    END.
    
    RUN openQueryStatic IN h-boin00961 (INPUT "Main":U) NO-ERROR.

     /*:T--- Verifica se o DBO j  est  inicializado ---*/
    IF NOT VALID-HANDLE(h-aqapi005) OR 
       h-aqapi005:TYPE <> "PROCEDURE":U OR
       h-aqapi005:FILE-NAME <> "aqp/aqapi005.p":U THEN DO:

        {btb/btb008za.i1 aqp/aqapi005.p YES}
        {btb/btb008za.i2 aqp/aqapi005.p '' h-aqapi005} 
    END.
    
    RUN openQueryStatic IN h-aqapi005 (INPUT "Main":U) NO-ERROR.    

    RETURN 'OK':U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-verifica-inativos wMaintenanceNoNavigation 
PROCEDURE pi-verifica-inativos :
/*------------------------------------------------------------------------------
  Purpose:     
------------------------------------------------------------------------------*/
  DEFINE VARIABLE i-status          AS INTEGER   NO-UNDO. /* 0-Inativo / 1-Ativo */
  DEFINE VARIABLE i-seq             AS INTEGER   NO-UNDO.
  DEFINE VARIABLE c-ptoColeta       AS CHARACTER NO-UNDO.
  DEFINE VARIABLE c-codPropried     AS CHARACTER NO-UNDO.
  DEFINE VARIABLE i-produtorRural   AS INTEGER     NO-UNDO.
  DEFINE VARIABLE r-produtPtoColeta AS ROWID     NO-UNDO. 

  EMPTY TEMP-TABLE rowErrors.

  ASSIGN c-ptoColeta = tt-pto-coleta.cod-pto-coleta:SCREEN-VALUE IN FRAME fPage0.

  RUN goToKey IN h-boin00966 (INPUT c-ptoColeta) NO-ERROR.

  RUN getCharField IN h-boin00966 (INPUT "cod-propried":U,
                                  OUTPUT c-codPropried).

  /* -- An lise: Relacionamento Produtor/Ponto de coleta -- */  
  ASSIGN i-produtorRural = INT(tt-produt-carg.cdn-produt-rural:SCREEN-VALUE IN FRAME fPage1).

  RUN goToKey IN h-boin00990 (INPUT i-produtorRural,
                              INPUT c-ptoColeta,
                              INPUT c-codPropried).

  IF RETURN-VALUE = "OK":U THEN DO:

    RUN getRowid IN h-boin00990 (OUTPUT r-produtPtoColeta).
    
    RUN piInicial IN h-aqapi005 (INPUT "Consultar":U,       /* A‡Æo     */
                                 INPUT "produtPtoColeta":U, /* Cadastro */ 
                                 INPUT r-produtPtoColeta,   /* Tabela   */
                                OUTPUT i-status,            /* Status   */
                          INPUT-OUTPUT TABLE rowErrors).

    IF i-status = 0 /* Inativo*/ THEN DO:

      FIND LAST rowErrors NO-ERROR.
      IF AVAIL rowErrors THEN
        ASSIGN i-seq = rowErrors.errorSequence + 1.
      ELSE 
        ASSIGN i-seq = 1.
      
      CREATE rowErrors.
      ASSIGN rowErrors.errorSequence    = i-seq
             rowErrors.errorNumber      = 55219.

      {utp/ut-liter.i Relacionamento_Inativo! }
      ASSIGN rowErrors.errorDescription = RETURN-VALUE.

      RUN utp/ut-msgs.p (INPUT "help":U,
                         INPUT 55219,
                         INPUT STRING(c-ptoColeta) + "~~" +
                               STRING(i-produtorRural)).

      ASSIGN rowErrors.errorHelp        = RETURN-VALUE
             RowErrors.ErrorType        = "EMS":U
             RowErrors.ErrorSubType     = "ERROR":U.
    END.
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE atualizaCodPropried wMaintenanceNoNavigation 
PROCEDURE atualizaCodPropried :
/*:T------------------------------------------------------------------------------
 Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    RUN findPropried IN h-boin00990 (INPUT INPUT FRAME fpage1 tt-produt-carg.cdn-produt-rural,
                                     INPUT INPUT FRAME fpage0 tt-pto-coleta.cod-pto-coleta  ,
                                     OUTPUT c-cod-propried).

    IF tt-produt-carg.cod-propried = '' THEN
        ASSIGN tt-produt-carg.cod-propried = c-cod-propried.
    
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

    DEFINE VARIABLE i-cdn-identif AS INTEGER NO-UNDO.

    RUN getCreateSequence IN {&hDBOTable} (OUTPUT i-cdn-identif). 
    
    ASSIGN v_cdn-identif = i-cdn-identif.

    ASSIGN {&ttTable}.cdn-identif = i-cdn-identif
           {&ttTable}.cod-pto-coleta = {&ttParent}.cod-pto-coleta.

    RUN goToKey IN h-boin00965-2 (INPUT prCdnIdentif) NO-ERROR.    

    RUN getIntField  IN h-boin00965-2 (INPUT "num-carg":U,           OUTPUT {&ttTable}.num-carg)            NO-ERROR.
    RUN getCharField IN h-boin00965-2 (INPUT "cod-estabel":U,        OUTPUT {&ttTable}.cod-estabel)         NO-ERROR.
    RUN getDateField IN h-boin00965-2 (INPUT "dat-trans":U,          OUTPUT {&ttTable}.dat-trans)           NO-ERROR.
    RUN getIntField  IN h-boin00965-2 (INPUT "cdn-produt-respons":U, OUTPUT {&ttTable}.cdn-produt-respons)  NO-ERROR.
    RUN getCharField IN h-boin00965-2 (INPUT "it-codigo":U,          OUTPUT {&ttTable}.it-codigo)           NO-ERROR.
    RUN getDecField  IN h-boin00965-2 (INPUT "val-temperat":U,       OUTPUT {&ttTable}.val-temperat)        NO-ERROR.
    RUN getIntField  IN h-boin00965-2 (INPUT "cdn-compart":U,        OUTPUT {&ttTable}.cdn-compart)         NO-ERROR.
    RUN getIntField  IN h-boin00965-2 (INPUT "cdn-sit":U,            OUTPUT {&ttTable}.cdn-sit)             NO-ERROR.
    RUN getIntField  IN h-boin00965-2 (INPUT "cdn-repos":U,          OUTPUT {&ttTable}.cdn-repos)           NO-ERROR.
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

