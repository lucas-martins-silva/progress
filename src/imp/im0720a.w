&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          mgcex            PROGRESS
*/
&Scoped-define WINDOW-NAME wMaintenanceNoNavigation


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE tt-adiant-despes NO-UNDO LIKE adiant-despes
       field r-rowid as rowid.
DEFINE TEMP-TABLE tt-adiant-despes-parc NO-UNDO LIKE adiant-despes-parc
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
{include/i-prgvrs.i IM0720A 2.00.00.002 } /*** 010002 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i IM0720A MIM}
&ENDIF

CREATE WIDGET-POOL.

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program           IM0720A
&GLOBAL-DEFINE Version           2.00.00.000
&GLOBAL-DEFINE DBOVersion        2.0

&GLOBAL-DEFINE Folder            NO
&GLOBAL-DEFINE InitialPage       1

&GLOBAL-DEFINE FolderLabels      

&GLOBAL-DEFINE ttTable           tt-adiant-despes
&GLOBAL-DEFINE hDBOTable         hDBOTable
&GLOBAL-DEFINE DBOTable          adiant-despes


&GLOBAL-DEFINE page0KeyFields    tt-adiant-despes.cod-estabel tt-adiant-despes.cdd-adiant
&GLOBAL-DEFINE page0Fields       tt-adiant-despes.dat-implant tt-adiant-despes.cdn-emitente ~
                                 tt-adiant-despes.cdn-moeda tt-adiant-despes.val-adiant-moed c-observacao

/* Parameters Definitions ---                                           */
DEFINE INPUT PARAMETER prTable         AS ROWID     NO-UNDO.
DEFINE INPUT PARAMETER pcAction        AS CHARACTER NO-UNDO.
DEFINE INPUT PARAMETER phCaller        AS HANDLE    NO-UNDO.

/* Local Variable Definitions ---                                       */
DEFINE NEW GLOBAL SHARED VARIABLE adm-broker-hdl AS HANDLE NO-UNDO.
DEFINE VARIABLE wh-pesquisa AS HANDLE NO-UNDO.

/* Local Variable Definitions (DBOs Handles) --- */
DEFINE VARIABLE {&hDBOTable}  AS HANDLE      NO-UNDO.
DEFINE VARIABLE h-boad107     AS HANDLE      NO-UNDO.
DEFINE VARIABLE h-boad098     AS HANDLE      NO-UNDO.
DEFINE VARIABLE h-boun005     AS HANDLE      NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE MaintenanceNoNavigation
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fpage0

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS tt-adiant-despes.cod-estabel ~
tt-adiant-despes.cdn-emitente tt-adiant-despes.cdn-moeda ~
tt-adiant-despes.val-adiant-moed 
&Scoped-define ENABLED-TABLES tt-adiant-despes
&Scoped-define FIRST-ENABLED-TABLE tt-adiant-despes
&Scoped-Define ENABLED-OBJECTS rtKeys rtToolBar c-observacao btOK btSave ~
btCancel btHelp 
&Scoped-Define DISPLAYED-FIELDS tt-adiant-despes.cod-estabel ~
tt-adiant-despes.dat-implant tt-adiant-despes.cdd-adiant ~
tt-adiant-despes.cdn-emitente tt-adiant-despes.cdn-moeda ~
tt-adiant-despes.val-adiant-moed 
&Scoped-define DISPLAYED-TABLES tt-adiant-despes
&Scoped-define FIRST-DISPLAYED-TABLE tt-adiant-despes
&Scoped-Define DISPLAYED-OBJECTS c-desc-estabel c-desc-emitente ~
c-desc-moeda c-observacao 

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

DEFINE VARIABLE c-observacao AS CHARACTER 
     VIEW-AS EDITOR NO-WORD-WRAP SCROLLBAR-HORIZONTAL SCROLLBAR-VERTICAL
     SIZE 59 BY 5 NO-UNDO.

DEFINE VARIABLE c-desc-emitente AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 30 BY .88 NO-UNDO.

DEFINE VARIABLE c-desc-estabel AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 30 BY .88 NO-UNDO.

DEFINE VARIABLE c-desc-moeda AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 12 BY .88 NO-UNDO.

DEFINE RECTANGLE rtKeys
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 90 BY 5.5.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 90 BY 1.42
     BGCOLOR 7 .


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fpage0
     tt-adiant-despes.cod-estabel AT ROW 1.5 COL 19 COLON-ALIGNED WIDGET-ID 8
          VIEW-AS FILL-IN 
          SIZE 6 BY .88
     c-desc-estabel AT ROW 1.5 COL 25.14 COLON-ALIGNED NO-LABEL WIDGET-ID 16
     tt-adiant-despes.dat-implant AT ROW 1.5 COL 77.29 COLON-ALIGNED WIDGET-ID 10
          VIEW-AS FILL-IN 
          SIZE 10 BY .88
     tt-adiant-despes.cdd-adiant AT ROW 2.46 COL 19 COLON-ALIGNED WIDGET-ID 2
          LABEL "Adiantamento"
          VIEW-AS FILL-IN 
          SIZE 16 BY .88
     tt-adiant-despes.cdn-emitente AT ROW 3.42 COL 19 COLON-ALIGNED WIDGET-ID 4
          VIEW-AS FILL-IN 
          SIZE 10 BY .88
     c-desc-emitente AT ROW 3.42 COL 29.14 COLON-ALIGNED NO-LABEL WIDGET-ID 18
     tt-adiant-despes.cdn-moeda AT ROW 4.38 COL 19 COLON-ALIGNED WIDGET-ID 6
          LABEL "Moeda"
          VIEW-AS FILL-IN 
          SIZE 3 BY .88
     c-desc-moeda AT ROW 4.38 COL 22.14 COLON-ALIGNED NO-LABEL WIDGET-ID 20
     tt-adiant-despes.val-adiant-moed AT ROW 5.33 COL 19 COLON-ALIGNED WIDGET-ID 22
          LABEL "Valor Adiantamento"
          VIEW-AS FILL-IN 
          SIZE 20 BY .88
     c-observacao AT ROW 6.75 COL 12 LABEL "Observa‡Æo" WIDGET-ID 14
     btOK AT ROW 12.38 COL 2
     btSave AT ROW 12.38 COL 13
     btCancel AT ROW 12.38 COL 24
     btHelp AT ROW 12.38 COL 80
     rtKeys AT ROW 1 COL 1
     rtToolBar AT ROW 12.13 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 90.86 BY 12.58
         FONT 1 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: MaintenanceNoNavigation
   Allow: Basic,Browse,DB-Fields,Window,Query
   Add Fields to: Neither
   Other Settings: COMPILE
   Temp-Tables and Buffers:
      TABLE: tt-adiant-despes T "?" NO-UNDO mgcex adiant-despes
      ADDITIONAL-FIELDS:
          field r-rowid as rowid
      END-FIELDS.
      TABLE: tt-adiant-despes-parc T "?" NO-UNDO mgcex adiant-despes-parc
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
         HEIGHT             = 12.63
         WIDTH              = 90.86
         MAX-HEIGHT         = 22.67
         MAX-WIDTH          = 142.43
         VIRTUAL-HEIGHT     = 22.67
         VIRTUAL-WIDTH      = 142.43
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
/* SETTINGS FOR FILL-IN c-desc-emitente IN FRAME fpage0
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-desc-estabel IN FRAME fpage0
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-desc-moeda IN FRAME fpage0
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN tt-adiant-despes.cdd-adiant IN FRAME fpage0
   NO-ENABLE EXP-LABEL                                                  */
/* SETTINGS FOR FILL-IN tt-adiant-despes.cdn-moeda IN FRAME fpage0
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN tt-adiant-despes.dat-implant IN FRAME fpage0
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN tt-adiant-despes.val-adiant-moed IN FRAME fpage0
   EXP-LABEL                                                            */
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
    SAVE_block:
    DO TRANS ON ERROR UNDO SAVE_block, LEAVE SAVE_block:
       RUN saveRecord IN THIS-PROCEDURE.
       IF NOT CAN-FIND(FIRST RowErrors
                       WHERE RowErrors.ErrorSubType = "ERROR":U) THEN DO:
          APPLY "CLOSE":U TO THIS-PROCEDURE.          
       END.
       ELSE DO:
           UNDO SAVE_block, LEAVE SAVE_block.
       END.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btSave
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btSave wMaintenanceNoNavigation
ON CHOOSE OF btSave IN FRAME fpage0 /* Salvar */
DO:
    SAVE_block:
    DO TRANS ON ERROR UNDO SAVE_block, LEAVE SAVE_block:
       RUN saveRecord IN THIS-PROCEDURE.
       IF CAN-FIND(FIRST RowErrors
                       WHERE RowErrors.ErrorSubType = "ERROR":U) THEN DO:
           UNDO SAVE_block, LEAVE SAVE_block.
       END.
       RUN afterInitializeInterface.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tt-adiant-despes.cdn-emitente
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-adiant-despes.cdn-emitente wMaintenanceNoNavigation
ON F5 OF tt-adiant-despes.cdn-emitente IN FRAME fpage0 /* Emitente */
DO:
    {method/zoomfields.i &ProgramZoom="adzoom/z10ad098.w"
                         &FieldZoom1="cod-emitente"
                         &FieldScreen1="tt-adiant-despes.cdn-emitente"
                         &Frame1="fPage0"
                         &FieldZoom2="nome-abrev"
                         &FieldScreen2="c-desc-emitente"
                         &Frame2="fPage0"} 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-adiant-despes.cdn-emitente wMaintenanceNoNavigation
ON LEAVE OF tt-adiant-despes.cdn-emitente IN FRAME fpage0 /* Emitente */
DO:
    {method/ReferenceFields.i
      &HandleDBOLeave="h-boad098"
      &FindMethod="findCodigo"
      &KeyValue1="integer(tt-adiant-despes.cdn-emitente:SCREEN-VALUE IN FRAME fPage0)"
      &FieldName1="nome-emit"
      &FieldScreen1="c-desc-emitente"
      &Frame1="fPage0"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-adiant-despes.cdn-emitente wMaintenanceNoNavigation
ON MOUSE-SELECT-DBLCLICK OF tt-adiant-despes.cdn-emitente IN FRAME fpage0 /* Emitente */
DO:
    APPLY "F5":U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tt-adiant-despes.cdn-moeda
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-adiant-despes.cdn-moeda wMaintenanceNoNavigation
ON F5 OF tt-adiant-despes.cdn-moeda IN FRAME fpage0 /* Moeda */
DO:
  {include/zoomvar.i &prog-zoom=unzoom/z01un005.w
                      &campo=tt-adiant-despes.cdn-moeda
                      &campozoom=mo-codigo
                      &campo2=c-desc-moeda
                      &campozoom2=descricao}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-adiant-despes.cdn-moeda wMaintenanceNoNavigation
ON LEAVE OF tt-adiant-despes.cdn-moeda IN FRAME fpage0 /* Moeda */
DO:
    {method/referencefields.i 
      &HandleDBOLeave="h-boun005"
      &FindMethod="findCodigo"
      &KeyValue1="integer(tt-adiant-despes.cdn-moeda:SCREEN-VALUE IN FRAME fPage0)"
      &FieldName1="descricao"
      &FieldScreen1="c-desc-moeda"
      &Frame1="fPage0"}  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-adiant-despes.cdn-moeda wMaintenanceNoNavigation
ON MOUSE-SELECT-DBLCLICK OF tt-adiant-despes.cdn-moeda IN FRAME fpage0 /* Moeda */
DO:
  APPLY "F5":U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tt-adiant-despes.cod-estabel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-adiant-despes.cod-estabel wMaintenanceNoNavigation
ON F5 OF tt-adiant-despes.cod-estabel IN FRAME fpage0 /* Estabelecimento */
DO:
    {method/zoomfields.i &ProgramZoom="adzoom/z10ad107.w"
                         &FieldZoom1="cod-estabel"
                         &FieldScreen1="tt-adiant-despes.cod-estabel"
                         &Frame1="fPage0"
                         &FieldZoom2="nome"
                         &FieldScreen2="c-desc-estabel"
                         &Frame2="fPage0"
                         &EnableImplant=yes}  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-adiant-despes.cod-estabel wMaintenanceNoNavigation
ON LEAVE OF tt-adiant-despes.cod-estabel IN FRAME fpage0 /* Estabelecimento */
DO:
    DEF VAR p-cdd-adiant LIKE adiant-despes.cdd-adiant NO-UNDO.
    IF pcAction = "ADD":U OR pcAction = "COPY":U THEN DO:
       RUN piRetornaNrAdiant IN {&hDBOTable}(INPUT FRAME fpage0 tt-adiant-despes.cod-estabel, OUTPUT p-cdd-adiant).
       ASSIGN tt-adiant-despes.cdd-adiant:SCREEN-VALUE IN FRAME fPage0 = STRING(p-cdd-adiant).
    END.

    {method/referencefields.i 
      &HandleDBOLeave="h-boad107"
      &FindMethod="findCodigo"
      &KeyValue1="tt-adiant-despes.cod-estabel:SCREEN-VALUE IN FRAME fPage0"
      &FieldName1="nome"
      &FieldScreen1="c-desc-estabel"
      &Frame1="fPage0"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-adiant-despes.cod-estabel wMaintenanceNoNavigation
ON MOUSE-SELECT-DBLCLICK OF tt-adiant-despes.cod-estabel IN FRAME fpage0 /* Estabelecimento */
DO:
  APPLY "F5":U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wMaintenanceNoNavigation 


/*:T--- L¢gica para inicializa‡Æo do programam ---*/
tt-adiant-despes.cod-estabel:LOAD-MOUSE-POINTER("image/lupa.cur":U) IN FRAME fPage0.
tt-adiant-despes.cdn-emitente:LOAD-MOUSE-POINTER("image/lupa.cur":U) IN FRAME fPage0.
tt-adiant-despes.cdn-moeda:LOAD-MOUSE-POINTER("image/lupa.cur":U) IN FRAME fPage0.

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

    IF VALID-HANDLE(h-boad107) THEN DO:
        DELETE PROCEDURE h-boad107.
        ASSIGN h-boad107 = ?.
    END.

    IF VALID-HANDLE(h-boad098) THEN DO:
        DELETE PROCEDURE h-boad098.
        ASSIGN h-boad098 = ?.
    END.

    IF VALID-HANDLE(h-boun005) THEN DO:
        DELETE PROCEDURE h-boun005.
        ASSIGN h-boun005 = ?.
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

    IF pcAction = "ADD":U THEN DO:
        ASSIGN tt-adiant-despes.dat-implant:SCREEN-VALUE IN FRAME fPage0 = STRING(TODAY)
               c-observacao:SCREEN-VALUE IN FRAME fPage0 = "":U.     
    END.
    ELSE DO:
        IF AVAIL tt-adiant-despes THEN
            ASSIGN c-observacao:SCREEN-VALUE IN FRAME fPage0 = tt-adiant-despes.observacao 
                   tt-adiant-despes.dat-implant:SCREEN-VALUE IN FRAME fPage0 = STRING(tt-adiant-despes.dat-implant).
    END.

    

    APPLY "LEAVE":U TO tt-adiant-despes.cod-estabel.
    APPLY "LEAVE":U TO tt-adiant-despes.cdn-emitente.
    APPLY "LEAVE":U TO tt-adiant-despes.cdn-moeda.

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

    ENABLE c-observacao WITH FRAME fPage0.

    ASSIGN tt-adiant-despes.dat-implant:SENSITIVE IN FRAME fPage0   = NO
           tt-adiant-despes.cdd-adiant:SENSITIVE IN FRAME fPage0 = NO.

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

    IF AVAIL tt-adiant-despes THEN DO:

        ASSIGN tt-adiant-despes.idi-modul  = 1
               tt-adiant-despes.observacao = INPUT FRAME fPage0 c-observacao
               tt-adiant-despes.val-adiant = DEC(tt-adiant-despes.val-adiant-moed:SCREEN-VALUE IN FRAME fPage0). 
               
        IF pcAction = "ADD":U OR pcAction = "COPY":U THEN DO:
           ASSIGN tt-adiant-despes.val-adiant-orig  = dec(tt-adiant-despes.val-adiant-moed:SCREEN-VALUE IN FRAME fPage0).
        END.

    END.

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

    RUN adbo/boad107.p   PERSISTENT SET h-boad107.
    RUN adbo/boad098.p   PERSISTENT SET h-boad098.
    RUN unbo/boun005.p   PERSISTENT SET h-boun005.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE saveParentFields wMaintenanceNoNavigation 
PROCEDURE saveParentFields :
/*:T------------------------------------------------------------------------------
  Purpose:     Salva valores dos campos da tabela filho (tt-adiant-despes) com base
               nos campos da tabela pai ({&ttParent})
  Parameters:
  Notes:       Este m‚todo somente ‚ executado quando a vari vel pcAction
               possuir os valores ADD ou COPY
------------------------------------------------------------------------------*/

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

