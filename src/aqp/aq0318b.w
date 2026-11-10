&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          movind            PROGRESS
*/
&Scoped-define WINDOW-NAME wMaintenanceNoNavigation


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE tt-histor-naocfedade NO-UNDO LIKE histor-naocfedade
       field r-rowid as rowid.
DEFINE TEMP-TABLE tt-naocfedade-carg NO-UNDO LIKE naocfedade-carg
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
{include/i-prgvrs.i AQ0318B 2.00.00.003 } /*** 010003 ***/

/* Chamada a include do gerenciador de licen‡as. Necessario alterar os parametros */
/*                                                                                */
/* <programa>:  Informar qual o nome do programa.                                 */
/* <m¢dulo>:  Informar qual o m¢dulo a qual o programa pertence.                  */
/*
&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i AQ0318b MAQ}
&ENDIF*/

CREATE WIDGET-POOL.

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program           aq0318b
&GLOBAL-DEFINE Version        2.00.00.003

&GLOBAL-DEFINE Folder            NO
&GLOBAL-DEFINE InitialPage       1

&GLOBAL-DEFINE FolderLabels      

&GLOBAL-DEFINE ttTable           tt-histor-naocfedade
&GLOBAL-DEFINE hDBOTable         h-boin01010
&GLOBAL-DEFINE DBOTable          histor-naocfedade

&GLOBAL-DEFINE ttParent          tt-naocfedade-carg
&GLOBAL-DEFINE DBOParentTable    naocfedade-carg

&GLOBAL-DEFINE page0KeyFields    
&GLOBAL-DEFINE page0Fields       
&GLOBAL-DEFINE page0ParentFields tt-naocfedade-carg.num-carg tt-naocfedade-carg.cdn-naocfedade ~
                                 tt-naocfedade-carg.dat-trans fi-tp-naocfedade
&GLOBAL-DEFINE page1Fields       cb-acao edt-narrativa
                                 

/* Parameters Definitions ---                                           */
DEFINE INPUT PARAMETER prTable         AS ROWID     NO-UNDO.
DEFINE INPUT PARAMETER prParent        AS ROWID     NO-UNDO.
DEFINE INPUT PARAMETER pcAction        AS CHARACTER NO-UNDO.
DEFINE INPUT PARAMETER phCaller        AS HANDLE    NO-UNDO.
DEFINE INPUT PARAMETER piSonPageNumber AS INTEGER   NO-UNDO.

/* Local Variable Definitions ---                                       */
{utp/ut-glob.i}
DEF VAR aux-popula-combo-box AS CHAR FORMAT "x(32)" NO-UNDO.
DEF VAR p-seq-histor AS INT NO-UNDO.

/* Local Variable Definitions (DBOs Handles) --- */
DEFINE VARIABLE {&hDBOTable}  AS HANDLE NO-UNDO.
DEF VAR h-boin01009           AS HANDLE NO-UNDO.
DEF VAR c-rows-returned       AS INTEGER NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE MaintenanceNoNavigation
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fpage0

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS tt-naocfedade-carg.cdn-naocfedade ~
tt-naocfedade-carg.dat-trans tt-naocfedade-carg.num-carg 
&Scoped-define ENABLED-TABLES tt-naocfedade-carg
&Scoped-define FIRST-ENABLED-TABLE tt-naocfedade-carg
&Scoped-Define ENABLED-OBJECTS btHelp rtKeys rtToolBar fi-tp-naocfedade ~
btOK btSave btCancel 
&Scoped-Define DISPLAYED-FIELDS tt-naocfedade-carg.cdn-naocfedade ~
tt-naocfedade-carg.dat-trans tt-naocfedade-carg.num-carg 
&Scoped-define DISPLAYED-TABLES tt-naocfedade-carg
&Scoped-define FIRST-DISPLAYED-TABLE tt-naocfedade-carg
&Scoped-Define DISPLAYED-OBJECTS fi-tp-naocfedade 

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
     LABEL "" 
     SIZE 1 BY .08.

DEFINE BUTTON btOK 
     LABEL "OK" 
     SIZE 10 BY 1.

DEFINE BUTTON btSave 
     LABEL "Salvar" 
     SIZE 10 BY 1.

DEFINE VARIABLE fi-tp-naocfedade AS CHARACTER FORMAT "X(24)":U 
     LABEL "Tipo NC":U 
     VIEW-AS FILL-IN 
     SIZE 19 BY .79 NO-UNDO.

DEFINE RECTANGLE rtKeys
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 77 BY 3.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 77 BY 1.42
     BGCOLOR 7 .

DEFINE VARIABLE cb-acao AS INTEGER FORMAT ">9":U INITIAL 1 
     LABEL "A‡Æo":U 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEM-PAIRS "An lise",1
     DROP-DOWN-LIST
     SIZE 16 BY 1 NO-UNDO.

DEFINE VARIABLE edt-narrativa AS CHARACTER 
     VIEW-AS EDITOR SCROLLBAR-VERTICAL
     SIZE 72 BY 3.5 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fpage0
     btHelp AT ROW 1 COL 1 WIDGET-ID 12
     tt-naocfedade-carg.cdn-naocfedade AT ROW 1.5 COL 20 COLON-ALIGNED
          LABEL "NÆo Conformidade"
          VIEW-AS FILL-IN 
          SIZE 9 BY .88
     tt-naocfedade-carg.dat-trans AT ROW 1.5 COL 50 COLON-ALIGNED WIDGET-ID 4
          VIEW-AS FILL-IN 
          SIZE 12 BY .88
     tt-naocfedade-carg.num-carg AT ROW 2.5 COL 20 COLON-ALIGNED WIDGET-ID 8
          VIEW-AS FILL-IN 
          SIZE 9 BY .88
     fi-tp-naocfedade AT ROW 2.5 COL 50 COLON-ALIGNED
     btOK AT ROW 11.04 COL 2
     btSave AT ROW 11.04 COL 13
     btCancel AT ROW 11.04 COL 24
     rtKeys AT ROW 1 COL 1
     rtToolBar AT ROW 10.79 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 77.43 BY 11.5
         FONT 1 WIDGET-ID 100.

DEFINE FRAME fPage1
     cb-acao AT ROW 1.63 COL 6.57 COLON-ALIGNED WIDGET-ID 10
     edt-narrativa AT ROW 3.75 COL 4 NO-LABEL WIDGET-ID 12
     "Narrativa:" VIEW-AS TEXT
          SIZE 8 BY .54 AT ROW 3 COL 4 WIDGET-ID 8
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 4.04
         SIZE 77 BY 6.63
         FONT 1 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: MaintenanceNoNavigation
   Allow: Basic,Browse,DB-Fields,Window,Query
   Add Fields to: Neither
   Temp-Tables and Buffers:
      TABLE: tt-histor-naocfedade T "?" NO-UNDO movind histor-naocfedade
      ADDITIONAL-FIELDS:
          field r-rowid as rowid
      END-FIELDS.
      TABLE: tt-naocfedade-carg T "?" NO-UNDO movind naocfedade-carg
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
         HEIGHT             = 11.5
         WIDTH              = 77.43
         MAX-HEIGHT         = 39.04
         MAX-WIDTH          = 182.86
         VIRTUAL-HEIGHT     = 39.04
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
  NOT-VISIBLE,                                                          */
/* REPARENT FRAME */
ASSIGN FRAME fPage1:FRAME = FRAME fpage0:HANDLE.

/* SETTINGS FOR FRAME fpage0
   FRAME-NAME                                                           */
ASSIGN 
       btHelp:HIDDEN IN FRAME fpage0           = TRUE.

/* SETTINGS FOR FILL-IN tt-naocfedade-carg.cdn-naocfedade IN FRAME fpage0
   EXP-LABEL                                                            */
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
    RETURN "NOK":U.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btOK
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btOK wMaintenanceNoNavigation
ON CHOOSE OF btOK IN FRAME fpage0 /* OK */
DO:
    IF pcAction = "UPDATE" THEN
        RUN saveParentFields.

    RUN saveRecord IN THIS-PROCEDURE.
    IF RETURN-VALUE = "OK":U THEN
        APPLY "CLOSE":U TO THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btSave
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btSave wMaintenanceNoNavigation
ON CHOOSE OF btSave IN FRAME fpage0 /* Salvar */
DO:
    RUN saveRecord      IN THIS-PROCEDURE.
    RUN pi-limpa-campos IN THIS-PROCEDURE.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterDisplayFields wMaintenanceNoNavigation 
PROCEDURE afterDisplayFields :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    IF pcAction = "ADD" THEN DO:

        IF VALID-HANDLE({&hDBOTable}) THEN DO:
            
            RUN validateSequence IN {&hDBOTable} (INPUT {&ttParent}.cdn-naocfedade,
                                                  OUTPUT p-seq-histor).

            ASSIGN {&ttTable}.cdn-histor = p-seq-histor.
        END.
        
        ASSIGN fi-tp-naocfedade:SCREEN-VALUE IN FRAME fpage0 = {ininc/i01in01009.i 04 tt-naocfedade-carg.idi-tip-naocfedade}.
    END.


    IF pcAction = "UPDATE" THEN DO:
        IF AVAIL tt-histor-naocfedade THEN
            ASSIGN edt-narrativa:SCREEN-VALUE IN FRAME fpage1 = tt-histor-naocfedade.des-narrat
                   fi-tp-naocfedade:SCREEN-VALUE IN FRAME fpage0 = {ininc/i01in01009.i 04 tt-naocfedade-carg.idi-tip-naocfedade}.
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

    ASSIGN aux-popula-combo-box = {ininc/i01in01010.i 04 01} + ", 1,"
           aux-popula-combo-box = aux-popula-combo-box + {ininc/i01in01010.i 04 02} + ", 2,"
           aux-popula-combo-box = aux-popula-combo-box + {ininc/i01in01010.i 04 03} + ", 3".

    ASSIGN cb-acao:LIST-ITEM-PAIRS IN FRAME fpage1 = aux-popula-combo-box
           cb-acao = 1.
    
    DISP cb-acao WITH FRAME fpage1.

    IF AVAIL tt-histor-naocfedade AND pcAction = "UPDATE" THEN
        ASSIGN cb-acao:SCREEN-VALUE IN FRAME fpage1 = STRING(tt-histor-naocfedade.idi-tip-histor).

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
           {&hDBOTable}:FILE-NAME <> "inbo/boin01010.p":U THEN DO:
            RUN inbo/boin01010.p PERSISTENT SET {&hDBOTable}.
            RUN openQueryStatic IN {&hDBOTable} (INPUT 'Main').
    END.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-limpa-campos wMaintenanceNoNavigation 
PROCEDURE pi-limpa-campos :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    ASSIGN cb-acao       = 1
           edt-narrativa = "".

    DISPLAY cb-acao      
            edt-narrativa
            WITH FRAME fPage1.

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

    IF pcAction = "ADD" THEN DO:

        ASSIGN {&ttTable}.cdn-naocfedade = {&ttParent}.cdn-naocfedade
               {&ttTable}.dat-histor = TODAY
               {&ttTable}.cod-usuar = c-seg-usuario
               {&ttTable}.idi-tip-histor = int(cb-acao:SCREEN-VALUE IN FRAME fpage1)
               {&ttTable}.des-narrat = edt-narrativa:SCREEN-VALUE IN FRAME fpage1.
    END.
    
    IF pcAction = "UPDATE" THEN DO:

        ASSIGN {&ttTable}.dat-histor = TODAY
               {&ttTable}.idi-tip-histor = int(cb-acao:SCREEN-VALUE IN FRAME fpage1)
               {&ttTable}.des-narrat = edt-narrativa:SCREEN-VALUE IN FRAME fpage1.
    END.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

