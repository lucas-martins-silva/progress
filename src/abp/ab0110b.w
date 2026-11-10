&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          mgfro            PROGRESS
*/
&Scoped-define WINDOW-NAME wMaintenanceNoNavigation

/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE tt-mab-restdo-tab NO-UNDO LIKE mab-restdo-tab
       field r-rowid as rowid.
DEFINE TEMP-TABLE tt-mab-tab-restdo NO-UNDO LIKE mab-tab-restdo
       field r-rowid as rowid.


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS wMaintenanceNoNavigation 
/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i AB0110B 2.00.00.000}  /*** 010000 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i ab0110b MAB}
&ENDIF


/*:T*******************************************************************************
** Copyright DATASUL S.A. (1999)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/

CREATE WIDGET-POOL.

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program           AB0110B
&GLOBAL-DEFINE Version           2.00.00.000

&GLOBAL-DEFINE Folder            no
&GLOBAL-DEFINE InitialPage       1

/*&GLOBAL-DEFINE FolderLabels      <Folder1 ,Folder 2 ,... , Folder8>*/

&GLOBAL-DEFINE ttTable           tt-mab-restdo-tab
&GLOBAL-DEFINE hDBOTable         HDBOmab-restdo-tab
&GLOBAL-DEFINE DBOTable          mab-restdo-tab

&GLOBAL-DEFINE ttParent          tt-mab-tab-restdo
&GLOBAL-DEFINE DBOParentTable    tt-mab-tab-restdo

&GLOBAL-DEFINE page0KeyFields    tt-mab-restdo-tab.num-seq
&GLOBAL-DEFINE page0Fields       tt-mab-restdo-tab.des-restdo ~
                                 tt-mab-restdo-tab.log-admit
&GLOBAL-DEFINE page0ParentFields tt-mab-tab-restdo.num-tabela ~
                                 tt-mab-tab-restdo.des-tabela

/* Parameters Definitions ---                                           */
DEFINE INPUT PARAMETER prTable         AS ROWID     NO-UNDO.
DEFINE INPUT PARAMETER prParent        AS ROWID     NO-UNDO.
DEFINE INPUT PARAMETER pcAction        AS CHARACTER NO-UNDO.
DEFINE INPUT PARAMETER phCaller        AS HANDLE    NO-UNDO.
DEFINE INPUT PARAMETER piSonPageNumber AS INTEGER   NO-UNDO.

/* Local Variable Definitions ---                                       */
DEFINE VARIABLE iTabOrig    AS INTEGER   NO-UNDO.
DEFINE VARIABLE cDescOrig   AS CHARACTER NO-UNDO.
DEFINE VARIABLE iTabDest    AS INTEGER   NO-UNDO.
DEFINE VARIABLE cDescDest   AS CHARACTER NO-UNDO.
DEF VAR cSeqOrig AS CHAR NO-UNDO.
DEF VAR cResOrig AS CHAR NO-UNDO.
DEF VAR cLAdOrig AS CHAR NO-UNDO.
DEF VAR cSeqDest AS CHAR NO-UNDO.
DEF VAR cResDest AS CHAR NO-UNDO.
DEF VAR cLAdDest AS CHAR NO-UNDO.

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
&Scoped-Define ENABLED-FIELDS tt-mab-tab-restdo.num-tabela ~
tt-mab-tab-restdo.des-tabela tt-mab-restdo-tab.num-seq ~
tt-mab-restdo-tab.des-restdo tt-mab-restdo-tab.log-admit 
&Scoped-define ENABLED-TABLES tt-mab-tab-restdo tt-mab-restdo-tab
&Scoped-define FIRST-ENABLED-TABLE tt-mab-tab-restdo
&Scoped-define SECOND-ENABLED-TABLE tt-mab-restdo-tab
&Scoped-Define ENABLED-OBJECTS btOK btSave btCancel btHelp rtKeys rtKeys-1 ~
rtToolBar 
&Scoped-Define DISPLAYED-FIELDS tt-mab-tab-restdo.num-tabela ~
tt-mab-tab-restdo.des-tabela tt-mab-restdo-tab.num-seq ~
tt-mab-restdo-tab.des-restdo tt-mab-restdo-tab.log-admit 
&Scoped-define DISPLAYED-TABLES tt-mab-tab-restdo tt-mab-restdo-tab
&Scoped-define FIRST-DISPLAYED-TABLE tt-mab-tab-restdo
&Scoped-define SECOND-DISPLAYED-TABLE tt-mab-restdo-tab


/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR wMaintenanceNoNavigation AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON btCancel 
     LABEL "&Cancelar" 
     SIZE 10 BY 1.

DEFINE BUTTON btHelp 
     LABEL "&Ajuda" 
     SIZE 10 BY 1.

DEFINE BUTTON btOK 
     LABEL "&OK" 
     SIZE 10 BY 1.

DEFINE BUTTON btSave 
     LABEL "&Salvar" 
     SIZE 10 BY 1.

DEFINE RECTANGLE rtKeys
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 90 BY 2.5.

DEFINE RECTANGLE rtKeys-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 90 BY 1.25.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE  
     SIZE 90 BY 1.42
     BGCOLOR 7 .


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fpage0
     tt-mab-tab-restdo.num-tabela AT ROW 1.5 COL 20 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 8 BY .88
     tt-mab-tab-restdo.des-tabela AT ROW 1.5 COL 28.57 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 40 BY .88
     tt-mab-restdo-tab.num-seq AT ROW 2.58 COL 20 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 8 BY .88
     tt-mab-restdo-tab.des-restdo AT ROW 4.21 COL 20 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 49 BY .88
     tt-mab-restdo-tab.log-admit AT ROW 4.25 COL 76
          VIEW-AS TOGGLE-BOX
          SIZE 11.72 BY .88
     btOK AT ROW 5.67 COL 2
     btSave AT ROW 5.67 COL 13
     btCancel AT ROW 5.67 COL 24
     btHelp AT ROW 5.67 COL 80
     rtKeys AT ROW 1.25 COL 1
     rtKeys-1 AT ROW 4 COL 1
     rtToolBar AT ROW 5.42 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 90 BY 6.25
         FONT 1.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: MaintenanceNoNavigation
   Allow: Basic,Browse,DB-Fields,Window,Query
   Add Fields to: Neither
   Temp-Tables and Buffers:
      TABLE: tt-mab-restdo-tab T "?" NO-UNDO mgfro mab-restdo-tab
      ADDITIONAL-FIELDS:
          field r-rowid as rowid
      END-FIELDS.
      TABLE: tt-mab-tab-restdo T "?" NO-UNDO mgfro mab-tab-restdo
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
         HEIGHT             = 6.25
         WIDTH              = 90.43
         MAX-HEIGHT         = 29
         MAX-WIDTH          = 146.29
         VIRTUAL-HEIGHT     = 29
         VIRTUAL-WIDTH      = 146.29
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


/*     if pcAction = "COPY":U then do:                                  */
/*         assign iTabDest = input frame fPage0 {&ttparent}.num-tabela  */
/*                cDescDest = input frame fPage0 {&ttParent}.des-tabela */
/*                cSeqDest  = INPUT FRAME fpage0 {&ttTable}.num-seq     */
/*                cResDest  = INPUT FRAME fpage0 {&ttTable}.des-restdo  */
/*                cLAdDest  = INPUT FRAME fpage0 {&ttTable}.log-admit.  */
/*     end.                                                             */
/*     IF RETURN-VALUE = "OK":U THEN do:                                */
/*         /** Faz a c¢pia das tabelas filhas para a tabela criada **/  */
/*         if pcAction = "COPY":U then do:                              */
/*             run copiaFilhos in {&hDBOTable} (input  iTabOrig,        */
/*                                              input  cDescOrig,       */
/*                                              input  cSeqOrig,        */
/*                                              input  cResOrig,        */
/*                                              input  cLAdOrig,        */
/*                                              INPUT  cSeqDest,        */
/*                                              INPUT  cResDest,        */
/*                                              INPUT  cLAdDest,        */
/*                                              input  iTabDest,        */
/*                                              input  cDescDest).      */
/*             /** Mostra Avisos **/                                    */
/*             if return-value = "WARNING":U then                       */
/*                 run piMostraErros in this-procedure.                 */
/*             run piReposiciona in phCaller.                           */
/*         end.                                                         */
        /** Fecha Programa **/
    IF RETURN-VALUE = "OK":U THEN
        APPLY "CLOSE":U TO THIS-PROCEDURE.
/*     end. */                

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


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wMaintenanceNoNavigation 


/*:T--- L¢gica para inicializa‡Æo do programam ---*/
{maintenancenonavigation/mainblock.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterEnableFields wMaintenanceNoNavigation 
PROCEDURE afterEnableFields :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
if pcAction = "ADD":U then do:
    /** Busca Pr¢ximo N£mero da Sequˆncia **/
    run buscaSequencia in {&hDBOTable} (input  {&ttParent}.num-tabela,
                                        output {&ttTable}.num-seq).
    display {&ttTable}.num-seq with frame fPage0.
end.
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
    /**Atualiza campo da copia**/
   
   ASSIGN tt-mab-restdo-tab.num-tabela = tt-mab-tab-restdo.num-tabela. 
  
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

