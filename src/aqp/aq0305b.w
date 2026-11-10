&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          movind            PROGRESS
*/
&Scoped-define WINDOW-NAME wMaintenanceNoNavigation


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE tt-carg-rural NO-UNDO LIKE carg-rural
       field r-rowid as rowid.
DEFINE TEMP-TABLE tt-liber-carg NO-UNDO LIKE liber-carg
       field r-rowid as rowid.
DEFINE TEMP-TABLE tt-liber-carg-aux NO-UNDO LIKE liber-carg
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
{include/i-prgvrs.i AQ0305B 2.00.00.008 } /*** 010008 ***/

/* Chamada a include do gerenciador de licen‡as. Necessario alterar os parametros */
/*                                                                                */
/* <programa>:  Informar qual o nome do programa.                                 */
/* <m¢dulo>:  Informar qual o m¢dulo a qual o programa pertence.                  */

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i aq0305b MAQ}
&ENDIF

CREATE WIDGET-POOL.

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program           aq0305b
&GLOBAL-DEFINE Version        2.00.00.008

&GLOBAL-DEFINE Folder            NO
&GLOBAL-DEFINE InitialPage       1

&GLOBAL-DEFINE FolderLabels      

&GLOBAL-DEFINE ttTable           tt-liber-carg
&GLOBAL-DEFINE hDBOTable         h-boin00982
&GLOBAL-DEFINE DBOTable          liber-carg

&GLOBAL-DEFINE ttParent          tt-carg-rural
&GLOBAL-DEFINE DBOParentTable    h-boin00961

&GLOBAL-DEFINE page0KeyFields    tt-liber-carg.cdn-compart
     
&GLOBAL-DEFINE page0Fields       tt-liber-carg.cod-depos tt-liber-carg.lote tt-liber-carg.dt-vali-lote tt-liber-carg.val-quant   
&GLOBAL-DEFINE page0ParentFields 
     

/* Parameters Definitions ---                                           */
DEFINE INPUT PARAMETER prTable         AS ROWID     NO-UNDO.
DEFINE INPUT PARAMETER prParent        AS ROWID     NO-UNDO.
DEFINE INPUT PARAMETER pcAction        AS CHARACTER NO-UNDO.
DEFINE INPUT PARAMETER phCaller        AS HANDLE    NO-UNDO.
DEFINE INPUT PARAMETER piSonPageNumber AS INTEGER   NO-UNDO.
DEFINE INPUT PARAMETER pl-dividir      AS LOGICAL   NO-UNDO.

/* Local Variable Definitions ---                                       */

/* Local Variable Definitions (DBOs Handles) --- */
DEFINE VARIABLE {&hDBOTable}  AS HANDLE NO-UNDO.
DEFINE VARIABLE wh-pesquisa   AS HANDLE NO-UNDO.
DEFINE VARIABLE h-boin084     AS HANDLE NO-UNDO.  /* deposito */
DEFINE VARIABLE h-boin172na   AS HANDLE NO-UNDO. /* item */
DEFINE VARIABLE h-boin00983   AS HANDLE NO-UNDO. /* item-estab-rural */
DEFINE VARIABLE h-boin417     AS HANDLE NO-UNDO. /* tab-unidade  */


DEFINE NEW GLOBAL SHARED VARIABLE adm-broker-hdl AS HANDLE NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE MaintenanceNoNavigation
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fpage0

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS tt-liber-carg.cdn-compart tt-liber-carg.lote ~
tt-liber-carg.dt-vali-lote tt-liber-carg.cod-depos tt-liber-carg.val-quant 
&Scoped-define ENABLED-TABLES tt-liber-carg
&Scoped-define FIRST-ENABLED-TABLE tt-liber-carg
&Scoped-Define ENABLED-OBJECTS rtKeys rtToolBar fiDescDep btOK btSave ~
btCancel btHelp 
&Scoped-Define DISPLAYED-FIELDS tt-liber-carg.cdn-compart ~
tt-liber-carg.lote tt-liber-carg.dt-vali-lote tt-liber-carg.cod-depos ~
tt-liber-carg.val-quant 
&Scoped-define DISPLAYED-TABLES tt-liber-carg
&Scoped-define FIRST-DISPLAYED-TABLE tt-liber-carg
&Scoped-Define DISPLAYED-OBJECTS fiDescDep 

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

DEFINE VARIABLE fiDescDep AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 23.86 BY .88 NO-UNDO.

DEFINE RECTANGLE rtKeys
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 91 BY 2.25.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 91 BY 1.42
     BGCOLOR 7 .


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fpage0
     tt-liber-carg.cdn-compart AT ROW 1.71 COL 34.14 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 5 BY .88
     tt-liber-carg.lote AT ROW 3.67 COL 34.14 COLON-ALIGNED WIDGET-ID 8
          VIEW-AS FILL-IN 
          SIZE 29.72 BY .88
     tt-liber-carg.dt-vali-lote AT ROW 4.67 COL 34.14 COLON-ALIGNED WIDGET-ID 6
          VIEW-AS FILL-IN 
          SIZE 13.29 BY .88
     tt-liber-carg.cod-depos AT ROW 5.63 COL 34.14 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 5.86 BY .88
     fiDescDep AT ROW 5.63 COL 40 COLON-ALIGNED NO-LABEL
     tt-liber-carg.val-quant AT ROW 6.63 COL 34.14 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 13.29 BY .88
     btOK AT ROW 8.21 COL 1.86
     btSave AT ROW 8.21 COL 12.14 WIDGET-ID 16
     btCancel AT ROW 8.21 COL 22.43
     btHelp AT ROW 8.21 COL 81.14 WIDGET-ID 12
     rtKeys AT ROW 1.04 COL 1
     rtToolBar AT ROW 8 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 91.14 BY 8.5
         FONT 1 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: MaintenanceNoNavigation
   Allow: Basic,Browse,DB-Fields,Window,Query
   Add Fields to: Neither
   Other Settings: COMPILE
   Temp-Tables and Buffers:
      TABLE: tt-carg-rural T "?" NO-UNDO movind carg-rural
      ADDITIONAL-FIELDS:
          field r-rowid as rowid
      END-FIELDS.
      TABLE: tt-liber-carg T "?" NO-UNDO movind liber-carg
      ADDITIONAL-FIELDS:
          field r-rowid as rowid
      END-FIELDS.
      TABLE: tt-liber-carg-aux T "?" NO-UNDO movind liber-carg
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
         HEIGHT             = 8.42
         WIDTH              = 90.29
         MAX-HEIGHT         = 39.46
         MAX-WIDTH          = 182.86
         VIRTUAL-HEIGHT     = 39.46
         VIRTUAL-WIDTH      = 182.86
         MIN-BUTTON         = no
         MAX-BUTTON         = no
         RESIZE             = no
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
  RUN piSaveRecord IN THIS-PROCEDURE.
  IF RETURN-VALUE = 'OK':U THEN
      APPLY "CLOSE":U TO THIS-PROCEDURE.   
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btSave
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btSave wMaintenanceNoNavigation
ON CHOOSE OF btSave IN FRAME fpage0 /* Salvar */
DO:
    RUN piSaveRecord IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tt-liber-carg.cod-depos
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-liber-carg.cod-depos wMaintenanceNoNavigation
ON F5 OF tt-liber-carg.cod-depos IN FRAME fpage0 /* Dep¢sito */
DO:
     ASSIGN l-implanta = NO.
    {include/zoomvar.i &prog-zoom="inzoom/z01in084.w"
                     &campo=tt-liber-carg.cod-depos
                     &campozoom=cod-depos
                     &campo2=fiDescDep
                     &campozoom2=nome} 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-liber-carg.cod-depos wMaintenanceNoNavigation
ON LEAVE OF tt-liber-carg.cod-depos IN FRAME fpage0 /* Dep¢sito */
DO:
    {method/ReferenceFields.i
            &HandleDBOLeave="h-boin084"
            &KeyValue1="tt-liber-carg.cod-depos:screen-value in frame fPage0"
            &FieldName1="cod-depos"
            &FieldScreen1="cod-depos"
            &Frame1="fPage0"
            &FieldName2="nome"
            &FieldScreen2="fiDescDep"
            &Frame2="fPage0"}


END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-liber-carg.cod-depos wMaintenanceNoNavigation
ON MOUSE-SELECT-DBLCLICK OF tt-liber-carg.cod-depos IN FRAME fpage0 /* Dep¢sito */
DO:
  APPLY 'F5':U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wMaintenanceNoNavigation 


/*:T--- L¢gica para inicializa‡Æo do programam ---*/
 tt-liber-carg.cod-depos:LOAD-MOUSE-POINTER("image/lupa.cur":U) IN FRAME fPage0.
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
    IF VALID-HANDLE({&hDBOTable}) THEN
        RUN destroy IN {&hDBOTable} .

    IF VALID-HANDLE(h-boin084) THEN
        RUN destroy IN h-boin084 .

    IF VALID-HANDLE(h-boin172na) THEN
        RUN destroy IN h-boin172na .

    IF VALID-HANDLE(h-boin00983) THEN
        RUN destroy IN h-boin00983 .

    IF VALID-HANDLE(h-boin417) THEN
        RUN destroy IN h-boin417.
        
    RETURN "OK":U.
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
    DEFINE VARIABLE i-tipo-con-est   AS INTEGER   NO-UNDO.  
    DEFINE VARIABLE i-idi-tip-aferic AS INTEGER   NO-UNDO.
    DEFINE VARIABLE i-dimensao       AS INTEGER   NO-UNDO.
    DEFINE VARIABLE c-un             AS CHARACTER NO-UNDO.
    DEFINE VARIABLE l-pesagem        AS LOGICAL   NO-UNDO.
    DEFINE VARIABLE l-fraciona       AS LOGICAL   NO-UNDO.
    
    /* item */
    RUN goToKey IN h-boin172na (INPUT tt-carg-rural.it-codigo).
    IF RETURN-VALUE = 'OK':U THEN DO:
        RUN getIntField IN h-boin172na (INPUT 'tipo-con-est':U, OUTPUT i-tipo-con-est). 
       
        ASSIGN tt-liber-carg.lote:SENSITIVE         IN FRAME fPage0 = i-tipo-con-est = 3 /* lote */
               tt-liber-carg.dt-vali-lote:SENSITIVE IN FRAME fPage0 = i-tipo-con-est = 3.

        RUN getCharField IN h-boin172na (INPUT 'un':U, OUTPUT c-un). 
        RUN getLogField IN h-boin172na (INPUT 'fraciona':U, OUTPUT l-fraciona). 

    END.

    /*tab-unidade*/
    RUN goToKey IN h-boin417(INPUT c-un).
     IF RETURN-VALUE = 'OK':U THEN
        RUN getIntField IN h-boin417(INPUT 'dimensao':U, OUTPUT i-dimensao). 

    /*item-estab-rural*/
    RUN goToKey IN h-boin00983 (INPUT tt-carg-rural.it-codigo, INPUT tt-carg-rural.cod-estabel).
    IF RETURN-VALUE = 'OK':U THEN 
        RUN getIntField IN h-boin00983 (INPUT 'idi-tip-aferic':U, OUTPUT i-idi-tip-aferic). 


   /*  Se o compartimento já foi descarregado, desbilita quantidade.   
       Senao    
       i-idi-tip-aferic = 1 => PESO 
       i-dimensao = 4       => VOLUMETRICA
       i-dimensao = 1       => PESO       
      */
    IF NOT l-fraciona THEN 
        ASSIGN tt-liber-carg.val-quant:FORMAT IN FRAME fpage0 = '>>>>,>>>,>>9':U.

    IF tt-liber-carg.idi-autoriz-descarga = 2 THEN
        ASSIGN tt-liber-carg.val-quant:SENSITIVE IN FRAME fPage0 = NO.
    ELSE 
       ASSIGN l-pesagem = i-idi-tip-aferic = 1 AND (i-dimensao = 1 OR i-dimensao = 4).
              tt-liber-carg.val-quant:SENSITIVE IN FRAME fPage0 = NOT l-pesagem. 

    IF pl-dividir THEN
        ASSIGN tt-liber-carg.val-quant:SENSITIVE IN FRAME fPage0    = YES
               tt-liber-carg.val-quant:SCREEN-VALUE IN FRAME fPage0 = '0'.
               
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
    APPLY 'LEAVE':U TO tt-liber-carg.cod-depos IN FRAME fPage0. 

    IF pl-dividir THEN
        ASSIGN tt-liber-carg.val-quant:SCREEN-VALUE IN FRAME fPage0 = '0'.
        
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
    /*:T--- Verifica se o DBO j  est  inicializado ---*/
    IF NOT VALID-HANDLE ({&hDBOTable}) OR 
           {&hDBOTable}:TYPE <> "PROCEDURE":U OR
           {&hDBOTable}:FILE-NAME <> "inbo/boin00982.p":U THEN DO:
            RUN  inbo/boin00982.p PERSISTENT SET {&hDBOTable}.
    END.
    
    RUN openQueryStatic in {&hDBOTable} (input "Main":U) NO-ERROR.

    /*:T--- Verifica se o DBO j  est  inicializado ---*/
    /* deposito */
    IF NOT VALID-HANDLE (h-boin084) OR 
          h-boin084:TYPE <> "PROCEDURE":U OR
          h-boin084:FILE-NAME <> "inbo/boin084.p":U THEN DO:
          RUN  inbo/boin084.p PERSISTENT SET  h-boin084.
    END.
    
    RUN openQueryStatic in  h-boin084 (input "Main":U) NO-ERROR.

    /*:T--- Verifica se o DBO j  est  inicializado ---*/
    /* item */
    IF NOT VALID-HANDLE (h-boin172na) OR 
          h-boin172na:TYPE <> "PROCEDURE":U OR
          h-boin172na:FILE-NAME <> "inbo/boin172na.p":U THEN DO:
          RUN inbo/boin172na.p PERSISTENT SET  h-boin172na.
    END.
    
    RUN openQueryStatic in  h-boin172na (input "Main":U) NO-ERROR.

    /* item-estab-rural */
    IF NOT VALID-HANDLE (h-boin00983) OR 
          h-boin00983:TYPE <> "PROCEDURE":U OR
          h-boin00983:FILE-NAME <> "inbo/boin172na.p":U THEN DO:
          RUN inbo/boin00983.p PERSISTENT SET  h-boin00983.
    END.
    
    RUN openQueryStatic in  h-boin00983 (input "Main":U) NO-ERROR.

        /* tab-unidade */
    IF NOT VALID-HANDLE (h-boin417) OR 
          h-boin417:TYPE <> "PROCEDURE":U OR
          h-boin417:FILE-NAME <> "inbo/boin172.p":U THEN DO:
          RUN inbo/boin417.p PERSISTENT SET  h-boin417.
    END.
    
    RUN openQueryStatic in  h-boin417(input "Main":U) NO-ERROR.

    RETURN 'OK':U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piSaveRecord wMaintenanceNoNavigation 
PROCEDURE piSaveRecord :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    IF  pl-dividir THEN DO:
    
        ASSIGN tt-liber-carg.lote         = INPUT FRAME fPage0  tt-liber-carg.lote         
               tt-liber-carg.dt-vali-lote = INPUT FRAME fPage0  tt-liber-carg.dt-vali-lote 
               tt-liber-carg.cod-depos    = INPUT FRAME fPage0  tt-liber-carg.cod-depos    
               tt-liber-carg.val-quant    = INPUT FRAME fPage0  tt-liber-carg.val-quant.   

        EMPTY TEMP-TABLE tt-liber-carg-aux NO-ERROR.

        CREATE tt-liber-carg-aux.
        BUFFER-COPY tt-liber-carg EXCEPT cdn-liber TO tt-liber-carg-aux.

        EMPTY TEMP-TABLE RowErrors NO-ERROR.
        RUN emptyRowErrors   IN {&hDBOTable}.
        
        RUN dividirLiberacao IN {&hDBOTable}(INPUT TABLE tt-liber-carg-aux).
        RUN getRowErrors     IN {&hDBOTable} (OUTPUT  TABLE RowErrors).
        IF CAN-FIND(FIRST RowErrors
                    WHERE RowErrors.ErrorType <> "INTERNAL":U) THEN DO: 
            {method/showmessage.i1}
            {method/showmessage.i2}
            RETURN "NOK":U.
        END.
    END.
    ELSE
        RUN saveRecord IN THIS-PROCEDURE.    

    RETURN RETURN-VALUE.

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

