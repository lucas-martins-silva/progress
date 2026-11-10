&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          emsdca            PROGRESS
*/
&Scoped-define WINDOW-NAME wMaintenanceNoNavigation


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE tt-af-controle NO-UNDO LIKE af-controle
       field r-rowid as rowid.
DEFINE TEMP-TABLE tt-af-faixa-demerito NO-UNDO LIKE af-faixa-demerito
       field r-rowid as rowid.



&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS wMaintenanceNoNavigation 
/*:T*******************************************************************************
** Copyright DATASUL S.A. (1999)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i AF0106A 2.00.00.001 } /*** 010001 ***/

CREATE WIDGET-POOL.

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program           AF0106A
&GLOBAL-DEFINE Version        2.00.00.001

&GLOBAL-DEFINE Folder            NO
&GLOBAL-DEFINE InitialPage       1

&GLOBAL-DEFINE FolderLabels      

&GLOBAL-DEFINE ttTable           tt-af-faixa-demerito
&GLOBAL-DEFINE hDBOTable         h-boaf010
&GLOBAL-DEFINE DBOTable          af-faixa-demerito

&GLOBAL-DEFINE ttParent          tt-af-controle
&GLOBAL-DEFINE DBOParentTable    h-boaf001

&GLOBAL-DEFINE page0KeyFields    tt-af-faixa-demerito.seq-faixa
&GLOBAL-DEFINE page0Fields       tt-af-faixa-demerito.lim-inicial tt-af-faixa-demerito.lim-final ~
                                 tt-af-faixa-demerito.demerito
&GLOBAL-DEFINE page0ParentFields tt-af-controle.nr-controle tt-af-controle.descricao ~
                                 tt-af-faixa-demerito.nr-versao desc-versao
   

/* Parameters Definitions ---                                           */
DEFINE INPUT PARAMETER prTable         AS ROWID     NO-UNDO.
DEFINE INPUT PARAMETER prParent        AS ROWID     NO-UNDO.
DEFINE INPUT PARAMETER pcAction        AS CHARACTER NO-UNDO.
DEFINE INPUT PARAMETER phCaller        AS HANDLE    NO-UNDO.
DEFINE INPUT PARAMETER piSonPageNumber AS INTEGER   NO-UNDO.

/* Local Variable Definitions ---                                       */
DEFINE VARIABLE inr-versao LIKE  tt-af-faixa-demerito.nr-versao   NO-UNDO.
DEFINE VARIABLE cdesc-versao LIKE af-versao-avaliacao.desc-versao   NO-UNDO.

/* Local Variable Definitions (DBOs Handles) --- */
DEFINE VARIABLE {&hDBOTable}  AS HANDLE NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE MaintenanceNoNavigation
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fpage0

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS tt-af-controle.nr-controle ~
tt-af-controle.descricao tt-af-faixa-demerito.seq-faixa ~
tt-af-faixa-demerito.lim-inicial tt-af-faixa-demerito.lim-final ~
tt-af-faixa-demerito.demerito 
&Scoped-define ENABLED-TABLES tt-af-controle tt-af-faixa-demerito
&Scoped-define FIRST-ENABLED-TABLE tt-af-controle
&Scoped-define SECOND-ENABLED-TABLE tt-af-faixa-demerito
&Scoped-Define ENABLED-OBJECTS IMAGE-65 IMAGE-69 RECT-16 RECT-17 RECT-18 ~
RECT-19 rtKeys rtToolBar btOK btSave btCancel btHelp 
&Scoped-Define DISPLAYED-FIELDS tt-af-controle.nr-controle ~
tt-af-controle.descricao tt-af-faixa-demerito.nr-versao ~
tt-af-faixa-demerito.seq-faixa tt-af-faixa-demerito.lim-inicial ~
tt-af-faixa-demerito.lim-final tt-af-faixa-demerito.demerito 
&Scoped-define DISPLAYED-TABLES tt-af-controle tt-af-faixa-demerito
&Scoped-define FIRST-DISPLAYED-TABLE tt-af-controle
&Scoped-define SECOND-DISPLAYED-TABLE tt-af-faixa-demerito
&Scoped-Define DISPLAYED-OBJECTS desc-versao 

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

DEFINE VARIABLE desc-versao AS CHARACTER FORMAT "X(40)":U 
     VIEW-AS FILL-IN 
     SIZE 42 BY .88 NO-UNDO.

DEFINE IMAGE IMAGE-65
     FILENAME "image/im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-69
     FILENAME "image/im-las":U
     SIZE 3 BY .88.

DEFINE RECTANGLE RECT-16
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 65.86 BY 1.71.

DEFINE RECTANGLE RECT-17
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 66 BY 2.75.

DEFINE RECTANGLE RECT-18
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 66 BY 1.71.

DEFINE RECTANGLE RECT-19
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 66 BY 1.75.

DEFINE RECTANGLE rtKeys
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 90 BY 9.5.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 90 BY 1.42
     BGCOLOR 7 .


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fpage0
     tt-af-controle.nr-controle AT ROW 1.75 COL 26 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 7 BY .88
     tt-af-controle.descricao AT ROW 1.75 COL 34 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 42 BY .88
     tt-af-faixa-demerito.nr-versao AT ROW 2.75 COL 26 COLON-ALIGNED
          LABEL "VersÆo"
          VIEW-AS FILL-IN 
          SIZE 7 BY .88
     desc-versao AT ROW 2.75 COL 34 COLON-ALIGNED NO-LABEL
     tt-af-faixa-demerito.seq-faixa AT ROW 4.63 COL 26 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 7 BY .88
     tt-af-faixa-demerito.lim-inicial AT ROW 6.58 COL 26 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 18 BY .88
     tt-af-faixa-demerito.lim-final AT ROW 6.58 COL 53.14 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 18 BY .88
     tt-af-faixa-demerito.demerito AT ROW 8.58 COL 26 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 9 BY .88
     btOK AT ROW 10.29 COL 2
     btSave AT ROW 10.29 COL 13
     btCancel AT ROW 10.29 COL 24
     btHelp AT ROW 10.29 COL 80
     IMAGE-65 AT ROW 6.58 COL 47
     IMAGE-69 AT ROW 6.58 COL 51
     RECT-16 AT ROW 6.13 COL 14
     RECT-17 AT ROW 1.25 COL 14
     RECT-18 AT ROW 8.08 COL 14
     RECT-19 AT ROW 4.13 COL 14
     rtKeys AT ROW 1 COL 1
     rtToolBar AT ROW 10.04 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 90 BY 10.67
         FONT 1.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: MaintenanceNoNavigation
   Allow: Basic,Browse,DB-Fields,Window,Query
   Add Fields to: Neither
   Temp-Tables and Buffers:
      TABLE: tt-af-controle T "?" NO-UNDO emsdca af-controle
      ADDITIONAL-FIELDS:
          field r-rowid as rowid
      END-FIELDS.
      TABLE: tt-af-faixa-demerito T "?" NO-UNDO emsdca af-faixa-demerito
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
         HEIGHT             = 10.63
         WIDTH              = 90.14
         MAX-HEIGHT         = 17
         MAX-WIDTH          = 90.43
         VIRTUAL-HEIGHT     = 17
         VIRTUAL-WIDTH      = 90.43
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
/* SETTINGS FOR FILL-IN desc-versao IN FRAME fpage0
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN tt-af-faixa-demerito.nr-versao IN FRAME fpage0
   NO-ENABLE EXP-LABEL                                                  */
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
    RUN saveRecord IN THIS-PROCEDURE.
    run afterSaveRecord IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wMaintenanceNoNavigation 


/*:T--- L¢gica para inicializa‡Æo do programam ---*/
{maintenancenonavigation/MainBlock.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterInitializeInterface wMaintenanceNoNavigation 
PROCEDURE afterInitializeInterface :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DISABLE tt-af-faixa-demerito.nr-versao
        desc-versao
    WITH FRAME fpahe0.

RUN pi-seta-versao IN phCaller (OUTPUT inr-versao, OUTPUT cdesc-versao).

ASSIGN tt-af-faixa-demerito.nr-versao:SCREEN-VALUE IN FRAME fpage0 = STRING(inr-versao)
       desc-versao:SCREEN-VALUE IN FRAME fpage0 = cdesc-versao.


if pcAction = "Add"  then do:
   run piProximaFaixa.
end.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterSaveRecord wMaintenanceNoNavigation 
PROCEDURE afterSaveRecord :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

run piProximaFaixa.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piProximaFaixa wMaintenanceNoNavigation 
PROCEDURE piProximaFaixa :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    run ProximaFaixa in h-boaf010 (input tt-af-controle.nr-controle, 
                                   INPUT inr-versao,
                                   input piSonPageNumber,
                                   output tt-af-faixa-demerito.seq-faixa,
                                   output tt-af-faixa-demerito.lim-inicial).
   display tt-af-faixa-demerito.seq-faixa
           tt-af-faixa-demerito.lim-inicial with frame fpage0.

   ASSIGN tt-af-faixa-demerito.nr-versao:SCREEN-VALUE IN FRAME fpage0 = STRING(inr-versao)
          desc-versao:SCREEN-VALUE IN FRAME fpage0 = cdesc-versao.

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
    
     assign tt-af-faixa-demerito.ind-tipo-valor = piSonPageNumber
            tt-af-faixa-demerito.ep-codigo = tt-af-controle.ep-codigo
            tt-af-faixa-demerito.nr-controle = tt-af-controle.nr-controle
            tt-af-faixa-demerito.nr-versao = inr-versao.
            
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

