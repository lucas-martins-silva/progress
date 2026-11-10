&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          movind            PROGRESS
          mgind            PROGRESS
*/
&Scoped-define WINDOW-NAME wMaintenanceNoNavigation


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE tt-dest-cust-naocfedade NO-UNDO LIKE dest-cust-naocfedade
       field r-rowid as rowid.
DEFINE TEMP-TABLE tt-naocfedade-carg NO-UNDO LIKE naocfedade-carg
       field r-rowid as rowid.
DEFINE TEMP-TABLE tt-propried-rural NO-UNDO LIKE propried-rural
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
{include/i-prgvrs.i AQ0318C 2.00.00.001 } /*** 010001 ***/

/* Chamada a include do gerenciador de licen‡as. Necessario alterar os parametros */
/*                                                                                */
/* <programa>:  Informar qual o nome do programa.                                 */
/* <m¢dulo>:  Informar qual o m¢dulo a qual o programa pertence.                  */

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i AQ0318c MAQ}
&ENDIF

CREATE WIDGET-POOL.

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program           aq0318c
&GLOBAL-DEFINE Version        2.00.00.001

&GLOBAL-DEFINE Folder            NO
&GLOBAL-DEFINE InitialPage       1
&GLOBAL-DEFINE FolderLabels      

&GLOBAL-DEFINE ttTable           tt-dest-cust-naocfedade
&GLOBAL-DEFINE hDBOTable         h-boin01013
&GLOBAL-DEFINE DBOTable          dest-cust-naocfedade

&GLOBAL-DEFINE ttParent          tt-naocfedade-carg
&GLOBAL-DEFINE DBOParentTable    naocfedade-carg

&GLOBAL-DEFINE page0KeyFields    
&GLOBAL-DEFINE page0Fields       
&GLOBAL-DEFINE page0ParentFields tt-naocfedade-carg.num-carg tt-naocfedade-carg.cdn-naocfedade
&GLOBAL-DEFINE page1Fields       rs-tipo tt-dest-cust-naocfedade.cdn-destin tt-dest-cust-naocfedade.dat-vencto tt-dest-cust-naocfedade.val-dest ~
                                 cb-propriedade 
                                       

/* Parameters Definitions ---                                           */
DEFINE INPUT PARAMETER prTable         AS ROWID     NO-UNDO.
DEFINE INPUT PARAMETER prParent        AS ROWID     NO-UNDO.
DEFINE INPUT PARAMETER pcAction        AS CHARACTER NO-UNDO.
DEFINE INPUT PARAMETER phCaller        AS HANDLE    NO-UNDO.
DEFINE INPUT PARAMETER piSonPageNumber AS INTEGER   NO-UNDO.

/* Local Variable Definitions ---                                       */
{utp/ut-glob.i}

/* Local Variable Definitions (DBOs Handles) --- */
DEFINE VARIABLE {&hDBOTable}       AS HANDLE    NO-UNDO.
DEFINE VARIABLE h-boin00961        AS HANDLE    NO-UNDO.
DEFINE VARIABLE h-boad098na        AS HANDLE    NO-UNDO.
DEFINE VARIABLE h-boin00980        AS HANDLE    NO-UNDO.
DEFINE VARIABLE h-boin00965        AS HANDLE    NO-UNDO.

DEFINE VARIABLE i-num-carg         AS INTEGER   NO-UNDO.
DEFINE VARIABLE p-seq-histor       AS INTEGER   NO-UNDO.
DEFINE VARIABLE c-list             AS CHARACTER NO-UNDO.
DEFINE VARIABLE c-cod-event-financ AS CHARACTER NO-UNDO.

DEFINE NEW GLOBAL SHARED VARIABLE adm-broker-hdl AS HANDLE NO-UNDO.
DEFINE VARIABLE wh-pesquisa    AS HANDLE      NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE MaintenanceNoNavigation
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fpage0

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS tt-naocfedade-carg.num-carg ~
tt-naocfedade-carg.cdn-naocfedade 
&Scoped-define ENABLED-TABLES tt-naocfedade-carg
&Scoped-define FIRST-ENABLED-TABLE tt-naocfedade-carg
&Scoped-Define ENABLED-OBJECTS rtKeys rtToolBar btOK btSave btCancel btHelp 
&Scoped-Define DISPLAYED-FIELDS tt-naocfedade-carg.num-carg ~
tt-naocfedade-carg.cdn-naocfedade 
&Scoped-define DISPLAYED-TABLES tt-naocfedade-carg
&Scoped-define FIRST-DISPLAYED-TABLE tt-naocfedade-carg


/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnEmitente wMaintenanceNoNavigation 
FUNCTION fnEmitente RETURNS CHARACTER
  ( INPUT iTipo AS INT, INPUT i-num-carg AS INTEGER, INPUT i-cod-emit AS INTEGER )  FORWARD.

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
     LABEL "" 
     SIZE .14 BY .08.

DEFINE BUTTON btOK 
     LABEL "OK" 
     SIZE 10 BY 1.

DEFINE BUTTON btSave 
     LABEL "Salvar" 
     SIZE 10 BY 1.

DEFINE RECTANGLE rtKeys
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 59 BY 3.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 59 BY 1.42
     BGCOLOR 7 .

DEFINE VARIABLE cb-propriedade AS CHARACTER FORMAT "X(256)":U 
     LABEL "Propriedade" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     DROP-DOWN-LIST
     SIZE 16 BY 1 NO-UNDO.

DEFINE VARIABLE fi-nome AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 24 BY .88 NO-UNDO.

DEFINE VARIABLE fi-nome-2 AS CHARACTER FORMAT "X(256)":U 
      VIEW-AS TEXT 
     SIZE 1 BY .88 NO-UNDO.

DEFINE VARIABLE rs-tipo AS INTEGER 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "Produtor", 1,
"Transportador", 2
     SIZE 24.86 BY .88 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fpage0
     tt-naocfedade-carg.num-carg AT ROW 1.58 COL 20.43 COLON-ALIGNED WIDGET-ID 6
          VIEW-AS FILL-IN 
          SIZE 9 BY .88
     tt-naocfedade-carg.cdn-naocfedade AT ROW 2.58 COL 20.43 COLON-ALIGNED
          LABEL "NÆo Conformidade"
          VIEW-AS FILL-IN 
          SIZE 9 BY .88
     btOK AT ROW 13.33 COL 2
     btSave AT ROW 13.33 COL 13
     btCancel AT ROW 13.33 COL 24
     btHelp AT ROW 14.58 COL 46 WIDGET-ID 2
     rtKeys AT ROW 1 COL 1
     rtToolBar AT ROW 13.08 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 60.43 BY 13.71
         FONT 1 WIDGET-ID 100.

DEFINE FRAME fPage1
     rs-tipo AT ROW 2.04 COL 21.14 NO-LABEL WIDGET-ID 2
     tt-dest-cust-naocfedade.cdn-destin AT ROW 3.04 COL 19.14 COLON-ALIGNED
          LABEL "Emitente"
          VIEW-AS FILL-IN 
          SIZE 8 BY .88
     fi-nome AT ROW 3.04 COL 27.29 COLON-ALIGNED NO-LABEL WIDGET-ID 22
     cb-propriedade AT ROW 4.04 COL 19.14 COLON-ALIGNED WIDGET-ID 26
     tt-dest-cust-naocfedade.dat-vencto AT ROW 5.04 COL 19.14 COLON-ALIGNED WIDGET-ID 14
          VIEW-AS FILL-IN 
          SIZE 11 BY .88
     tt-dest-cust-naocfedade.val-dest AT ROW 6.04 COL 19.14 COLON-ALIGNED
          LABEL "Valor" FORMAT ">>>>,>>>,>>9.9999"
          VIEW-AS FILL-IN 
          SIZE 14 BY .88
     fi-nome-2 AT ROW 5 COL 49 COLON-ALIGNED NO-LABEL WIDGET-ID 28
     "Penalizar:" VIEW-AS TEXT
          SIZE 7 BY .88 AT ROW 2 COL 13.86 WIDGET-ID 30
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1.14 ROW 4.5
         SIZE 59 BY 7.17
         FONT 1 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: MaintenanceNoNavigation
   Allow: Basic,Browse,DB-Fields,Window,Query
   Add Fields to: Neither
   Other Settings: COMPILE
   Temp-Tables and Buffers:
      TABLE: tt-dest-cust-naocfedade T "?" NO-UNDO movind dest-cust-naocfedade
      ADDITIONAL-FIELDS:
          field r-rowid as rowid
      END-FIELDS.
      TABLE: tt-naocfedade-carg T "?" NO-UNDO movind naocfedade-carg
      ADDITIONAL-FIELDS:
          field r-rowid as rowid
      END-FIELDS.
      TABLE: tt-propried-rural T "?" NO-UNDO mgind propried-rural
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
         HEIGHT             = 13.63
         WIDTH              = 59.43
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
ASSIGN 
       btHelp:HIDDEN IN FRAME fpage0           = TRUE.

/* SETTINGS FOR FILL-IN tt-naocfedade-carg.cdn-naocfedade IN FRAME fpage0
   EXP-LABEL                                                            */
/* SETTINGS FOR FRAME fPage1
                                                                        */
/* SETTINGS FOR FILL-IN tt-dest-cust-naocfedade.cdn-destin IN FRAME fPage1
   EXP-LABEL                                                            */
ASSIGN 
       fi-nome:READ-ONLY IN FRAME fPage1        = TRUE.

ASSIGN 
       fi-nome-2:READ-ONLY IN FRAME fPage1        = TRUE.

/* SETTINGS FOR FILL-IN tt-dest-cust-naocfedade.val-dest IN FRAME fPage1
   EXP-LABEL EXP-FORMAT                                                 */
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
    RETURN "NOK".
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btOK
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btOK wMaintenanceNoNavigation
ON CHOOSE OF btOK IN FRAME fpage0 /* OK */
DO:   
    RUN saveRecord IN THIS-PROCEDURE.        
    IF RETURN-VALUE = "OK":U THEN DO:
        APPLY "CLOSE":U TO THIS-PROCEDURE.
        RETURN "OK":U.
    END.
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


&Scoped-define FRAME-NAME fPage1
&Scoped-define SELF-NAME tt-dest-cust-naocfedade.cdn-destin
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-dest-cust-naocfedade.cdn-destin wMaintenanceNoNavigation
ON F5 OF tt-dest-cust-naocfedade.cdn-destin IN FRAME fPage1 /* Emitente */
DO:
    
   IF rs-tipo:SCREEN-VALUE IN FRAME fpage1 = "1" THEN DO: /* produtor */
        {method/zoomfields.i &ProgramZoom="inzoom/z01in00965.w"
            &FieldZoom1="cdn-produt-rural"
            &FieldScreen1="tt-dest-cust-naocfedade.cdn-destin"
            &Frame1="fpage1"  
            &FieldZoom2="nom-produtor"
            &FieldScreen2="fi-nome"
            &Frame2="fpage1"
            &EnableImplant="NO"
            &RunMethod="run setParams in hProgramZoom (INPUT tt-naocfedade-carg.num-carg)."}
            
        wait-for "CLOSE":U of hProgramZoom.
   END.
   ELSE DO:
       ASSIGN l-implanta = NO.
       {include/zoomvar.i &prog-zoom=adzoom/z07ad098.w
                          &campo=tt-dest-cust-naocfedade.cdn-destin
                          &campozoom=cod-emitente
                          &frame="fPage1"
                          &campo2=fi-nome
                          &campozoom2=nome-abrev
                          &frame2="fPage1"}.

   END.
   APPLY "VALUE-CHANGED":U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-dest-cust-naocfedade.cdn-destin wMaintenanceNoNavigation
ON LEAVE OF tt-dest-cust-naocfedade.cdn-destin IN FRAME fPage1 /* Emitente */
DO:

    DEFINE VARIABLE c-primeira-propried AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE c-nome-emit         AS CHARACTER   NO-UNDO.

    ASSIGN c-list = "".

    IF rs-tipo:SCREEN-VALUE IN FRAME fpage1 = "1" THEN DO: /* produtor */

         EMPTY TEMP-TABLE tt-propried-rural NO-ERROR.

         IF VALID-HANDLE(h-boin00980) THEN
             RUN buscaPropriedadeProdutor IN h-boin00980(INPUT INT(SELF:SCREEN-VALUE IN FRAME fpage1), OUTPUT TABLE tt-propried-rural).
 
         FOR EACH tt-propried-rural:
             IF c-list = "" THEN
                 ASSIGN c-primeira-propried = tt-propried-rural.cod-propried.    
             ELSE 
                 ASSIGN c-list = c-list + ",".
 
             ASSIGN c-list = c-list + tt-propried-rural.cod-propried + ',' + tt-propried-rural.cod-propried.
         END.
     
         IF c-list = "" THEN ASSIGN c-list = "," .  
     
         IF LOOKUP(fi-nome-2:SCREEN-VALUE IN FRAME fPage1, c-list) = 0 THEN 
             ASSIGN fi-nome-2:SCREEN-VALUE IN FRAME fPage1 = "".
     
         ASSIGN cb-propriedade:LIST-ITEM-PAIRS IN FRAME fPage1 = c-list
                cb-propriedade:SCREEN-VALUE    IN FRAME fPage1 = fi-nome-2:SCREEN-VALUE IN FRAME fPage1.
     
         IF fi-nome-2:SCREEN-VALUE IN FRAME fPage1 = "" THEN
             ASSIGN cb-propriedade:SCREEN-VALUE IN FRAME fPage1 = c-primeira-propried.
         ELSE
             ASSIGN cb-propriedade:SCREEN-VALUE IN FRAME fPage1 = fi-nome-2:SCREEN-VALUE IN FRAME fPage1.
 
    END.
    ELSE DO: 
        ASSIGN cb-propriedade:SENSITIVE       IN FRAME fpage1 = NO
               cb-propriedade:LIST-ITEM-PAIRS IN FRAME fpage1 = ",".
    END.

    ASSIGN c-nome-emit = fnEmitente(INPUT INT(rs-tipo:SCREEN-VALUE IN FRAME fpage1), INPUT tt-naocfedade-carg.num-carg, INPUT INT(SELF:SCREEN-VALUE IN FRAME fpage1)).

    IF c-nome-emit = "" THEN
        ASSIGN cb-propriedade:LIST-ITEM-PAIRS IN FRAME fpage1 = ",".

    ASSIGN fi-nome:SCREEN-VALUE IN FRAME fpage1 = c-nome-emit.      
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-dest-cust-naocfedade.cdn-destin wMaintenanceNoNavigation
ON MOUSE-SELECT-DBLCLICK OF tt-dest-cust-naocfedade.cdn-destin IN FRAME fPage1 /* Emitente */
DO:
  APPLY 'F5' TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-dest-cust-naocfedade.cdn-destin wMaintenanceNoNavigation
ON VALUE-CHANGED OF tt-dest-cust-naocfedade.cdn-destin IN FRAME fPage1 /* Emitente */
DO:
   APPLY "LEAVE":U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME rs-tipo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL rs-tipo wMaintenanceNoNavigation
ON VALUE-CHANGED OF rs-tipo IN FRAME fPage1
DO:
    DEFINE VARIABLE i-cod-transp   AS INTEGER     NO-UNDO.
    DEFINE VARIABLE i-cod-emitente AS INTEGER     NO-UNDO.
    
    DEFINE VARIABLE c-nome AS CHARACTER   NO-UNDO.

    
    IF rs-tipo:SCREEN-VALUE IN FRAME fpage1 = "1" THEN DO:
        ASSIGN tt-dest-cust-naocfedade.cdn-destin:SENSITIVE IN FRAME fpage1 = YES
               cb-propriedade:SENSITIVE                     IN FRAME fpage1 = YES.

        IF AVAIL tt-dest-cust-naocfedade THEN
            ASSIGN tt-dest-cust-naocfedade.cdn-destin:SCREEN-VALUE IN FRAME fpage1 = string(tt-dest-cust-naocfedade.cdn-destin).
    END.
    ELSE DO:
        IF VALID-HANDLE(h-boin00961) THEN DO:
            RUN goToKey IN h-boin00961 (INPUT tt-naocfedade-carg.num-carg).
            IF RETURN-VALUE = 'OK' THEN DO:
                RUN getIntField IN h-boin00961 (INPUT "cod-transp", OUTPUT i-cod-transp).

                RUN sugereEmitenteTransportador IN h-boin01013(INPUT i-cod-transp, OUTPUT i-cod-emitente).
                IF RETURN-VALUE = "OK" THEN DO:
                    ASSIGN  tt-dest-cust-naocfedade.cdn-destin:SCREEN-VALUE IN FRAME fPage1 = string(i-cod-emitente).
                END.
            END.
        END.
    END.

    APPLY 'LEAVE' TO tt-dest-cust-naocfedade.cdn-destin IN FRAME fpage1.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fpage0
&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wMaintenanceNoNavigation 


tt-dest-cust-naocfedade.cdn-destin:LOAD-MOUSE-POINTER("image/lupa.cur":U) IN FRAME fpage1.

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
    IF VALID-HANDLE(h-boad098na) THEN DO:
        DELETE PROCEDURE h-boad098na.
        ASSIGN h-boad098na = ?.
    END.

    IF VALID-HANDLE(h-boin00980) THEN DO:
        DELETE PROCEDURE h-boin00980.
        ASSIGN h-boin00980 = ?.
    END.

    IF VALID-HANDLE(h-boin00965) THEN DO:
        DELETE PROCEDURE h-boin00965.
        ASSIGN h-boin00965 = ?.
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
    IF pcAction = "ADD" THEN DO:
        IF VALID-HANDLE({&hDBOTable}) THEN DO:
            RUN validateSequence IN {&hDBOTable} (INPUT {&ttParent}.cdn-naocfedade,
                                                  OUTPUT p-seq-histor).
            ASSIGN {&ttTable}.cdn-seq-dest = p-seq-histor.
        END.
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
    IF pcAction = "Update" THEN DO:
        IF {&ttTable}.cod-propried = "" THEN
            ASSIGN rs-tipo:SCREEN-VALUE IN FRAME fPage1 = "2".

        APPLY "LEAVE" TO tt-dest-cust-naocfedade.cdn-destin IN FRAME fpage1.
        APPLY "VALUE-CHANGED" TO rs-tipo IN FRAME fpage1.
    END.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterSaveFields wMaintenanceNoNavigation 
PROCEDURE afterSaveFields :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
   DEFINE VARIABLE c-cod-propried AS CHARACTER   NO-UNDO.

   IF cb-propriedade:SCREEN-VALUE IN FRAME fpage1 <> ? THEN
       ASSIGN c-cod-propried = cb-propriedade:SCREEN-VALUE IN FRAME fpage1.

   ASSIGN {&ttTable}.cod-propried = c-cod-propried.

   RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE beforeSaveFields wMaintenanceNoNavigation 
PROCEDURE beforeSaveFields :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    IF VALID-HANDLE(h-boin01013) THEN 
        RUN setConstraintPenalizado IN h-boin01013(INPUT INT(rs-tipo:SCREEN-VALUE IN FRAME fPage1)).
    
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
           {&hDBOTable}:FILE-NAME <> "inbo/boin01013.p":U THEN DO:
            RUN inbo/boin01013.p PERSISTENT SET {&hDBOTable}.
            RUN openQueryStatic IN {&hDBOTable} (INPUT 'Main').
    END.

    IF NOT VALID-HANDLE (h-boin00961) THEN DO:
        RUN inbo/boin00961.p PERSISTENT SET h-boin00961.
        RUN openQueryStatic IN h-boin00961 (INPUT 'Main').
    END.

    IF NOT VALID-HANDLE (h-boad098na) THEN DO:
        RUN adbo/boad098na.p PERSISTENT SET h-boad098na.
        RUN openQueryStatic IN h-boad098na (INPUT 'Main').
    END.

    IF NOT VALID-HANDLE (h-boin00980) THEN DO:
        RUN inbo/boin00980.p PERSISTENT SET h-boin00980.
        RUN openQueryStatic IN h-boin00980(INPUT 'Main').
    END.

    IF NOT VALID-HANDLE (h-boin00965) THEN DO:
        RUN inbo/boin00965.p PERSISTENT SET h-boin00965.
        RUN openQueryStatic IN h-boin00965(INPUT 'Main').
    END.
    
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
    
    ASSIGN {&ttTable}.cdn-naocfedade = {&ttParent}.cdn-naocfedade.
    
    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fnEmitente wMaintenanceNoNavigation 
FUNCTION fnEmitente RETURNS CHARACTER
  ( INPUT iTipo AS INT, INPUT i-num-carg AS INTEGER, INPUT i-cod-emit AS INTEGER ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
    DEFINE VARIABLE cnome-abrev AS CHARACTER NO-UNDO.

    IF VALID-HANDLE(h-boin00965) AND VALID-HANDLE(h-boad098na) THEN DO:
        RUN can-find-produt-carg IN h-boin00965(INPUT i-num-carg, INPUT i-cod-emit).
        IF RETURN-VALUE = "OK" OR iTipo = 2 THEN DO:
            RUN goToKey IN h-boad098na (INPUT i-cod-emit).
            IF RETURN-VALUE = "OK":U THEN
                RUN getCharField IN h-boad098na (INPUT "nome-abrev", OUTPUT cnome-abrev).
        END.        
    END.  

  RETURN cnome-abrev.   /* Function return value. */
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

