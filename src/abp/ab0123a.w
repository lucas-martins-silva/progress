&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          mgfro            PROGRESS
*/
&Scoped-define WINDOW-NAME wMaintenanceNoNavigation


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE ttmab-eqpto NO-UNDO LIKE mab-eqpto
       FIELD R-ROWID AS ROWID.
DEFINE TEMP-TABLE ttmgf-eqpto-implto NO-UNDO LIKE mgf-eqpto-implto
       FIELD R-ROWID AS ROWID.



&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS wMaintenanceNoNavigation 
/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i AB0123A 2.00.00.003 } /*** "010003" ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i ab0123a MAB}
&ENDIF


/********************************************************************************
** Copyright DATASUL S.A. (1999)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/

CREATE WIDGET-POOL.

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program           AB0123A
&GLOBAL-DEFINE Version        2.00.00.002

&GLOBAL-DEFINE Folder            NO
&GLOBAL-DEFINE InitialPage       0

&GLOBAL-DEFINE FolderLabels      

&GLOBAL-DEFINE ttTable           ttmgf-eqpto-implto
&GLOBAL-DEFINE hDBOTable         hDBOMgfEqptoImplto
&GLOBAL-DEFINE DBOTable          mgf-eqpto-implto

&GLOBAL-DEFINE ttParent          ttmab-eqpto
&GLOBAL-DEFINE DBOParentTable    hDBOmab-eqpto

&GLOBAL-DEFINE page0KeyFields    ttmgf-eqpto-implto.dat-inicial ~
                                 ttmgf-eqpto-implto.dat-final   ~
                                 ttmgf-eqpto-implto.ep-codigo-eqpto ~
                                 ttmgf-eqpto-implto.cod-eqpto 
                                
                                  
&GLOBAL-DEFINE page0Fields       
&GLOBAL-DEFINE page0ParentFields ttmab-eqpto.ep-codigo ~
                                 ttmab-eqpto.cod-eqpto
                                  
&GLOBAL-DEFINE page1Fields       
                                  
                                  

&GLOBAL-DEFINE page2Fields       

/* Parameters Definitions ---                                           */
DEFINE INPUT PARAMETER prTable         AS ROWID     NO-UNDO.
DEFINE INPUT PARAMETER prParent        AS ROWID     NO-UNDO.
DEFINE INPUT PARAMETER pcAction        AS CHARACTER NO-UNDO.
DEFINE INPUT PARAMETER phCaller        AS HANDLE    NO-UNDO.
DEFINE INPUT PARAMETER piSonPageNumber AS INTEGER   NO-UNDO.
/* Local Variable Definitions ---                                       */
/* Local Variable Definitions (DBOs Handles) --- */
DEFINE VARIABLE {&hDBOTable}  AS HANDLE NO-UNDO.
DEFINE VARIABLE hDBOModelo    AS HANDLE NO-UNDO.
DEFINE VARIABLE hDBOEqpto     AS HANDLE NO-UNDO.
define variable cDescModel     as char   no-undo.
/** Zoom Smart **/
DEFINE NEW GLOBAL SHARED VARIABLE adm-broker-hdl AS HANDLE NO-UNDO.
DEFINE VARIABLE wh-pesquisa AS HANDLE NO-UNDO.
def new global shared var lImplto    as logical initial no no-undo.
def new global shared var lEqpto     as logical initial no no-undo.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE MaintenanceNoNavigation
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fpage0

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS ttmab-eqpto.ep-codigo ttmab-eqpto.cod-eqpto ~
ttmgf-eqpto-implto.dat-inicial ttmgf-eqpto-implto.dat-final ~
ttmgf-eqpto-implto.ep-codigo-eqpto ttmgf-eqpto-implto.cod-eqpto 
&Scoped-define ENABLED-TABLES ttmab-eqpto ttmgf-eqpto-implto
&Scoped-define FIRST-ENABLED-TABLE ttmab-eqpto
&Scoped-define SECOND-ENABLED-TABLE ttmgf-eqpto-implto
&Scoped-Define ENABLED-OBJECTS rtKeys rtKeys-2 rtToolBar fiEmpEqpto ~
fiDescEqpto fiEmpImplto fiDescImplto btOK btSave btCancel btHelp 
&Scoped-Define DISPLAYED-FIELDS ttmab-eqpto.ep-codigo ttmab-eqpto.cod-eqpto ~
ttmgf-eqpto-implto.dat-inicial ttmgf-eqpto-implto.dat-final ~
ttmgf-eqpto-implto.ep-codigo-eqpto ttmgf-eqpto-implto.cod-eqpto 
&Scoped-define DISPLAYED-TABLES ttmab-eqpto ttmgf-eqpto-implto
&Scoped-define FIRST-DISPLAYED-TABLE ttmab-eqpto
&Scoped-define SECOND-DISPLAYED-TABLE ttmgf-eqpto-implto
&Scoped-Define DISPLAYED-OBJECTS fiEmpEqpto fiDescEqpto fiEmpImplto ~
fiDescImplto 

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

DEFINE VARIABLE fiDescEqpto AS CHARACTER FORMAT "X(30)":U 
     VIEW-AS FILL-IN 
     SIZE 30 BY .88 NO-UNDO.

DEFINE VARIABLE fiDescImplto AS CHARACTER FORMAT "X(30)":U 
     VIEW-AS FILL-IN 
     SIZE 30 BY .88 NO-UNDO.

DEFINE VARIABLE fiEmpEqpto AS CHARACTER FORMAT "X(40)":U 
     VIEW-AS FILL-IN 
     SIZE 40.86 BY .88 NO-UNDO.

DEFINE VARIABLE fiEmpImplto AS CHARACTER FORMAT "X(30)":U 
     VIEW-AS FILL-IN 
     SIZE 40.86 BY .88 NO-UNDO.

DEFINE RECTANGLE rtKeys
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 90 BY 2.5.

DEFINE RECTANGLE rtKeys-2
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 90 BY 4.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 90 BY 1.42
     BGCOLOR 7 .


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fpage0
     ttmab-eqpto.ep-codigo AT ROW 1.33 COL 18 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 5 BY .88
     fiEmpEqpto AT ROW 1.33 COL 23.14 COLON-ALIGNED NO-LABEL
     ttmab-eqpto.cod-eqpto AT ROW 2.33 COL 18 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 16 BY .88
     fiDescEqpto AT ROW 2.33 COL 34.14 COLON-ALIGNED NO-LABEL
     ttmgf-eqpto-implto.dat-inicial AT ROW 4 COL 18 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 10 BY .88
     ttmgf-eqpto-implto.dat-final AT ROW 4 COL 54 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 10 BY .88
     ttmgf-eqpto-implto.ep-codigo-eqpto AT ROW 5 COL 18.14 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 5 BY .88
     fiEmpImplto AT ROW 5 COL 23.14 COLON-ALIGNED NO-LABEL
     ttmgf-eqpto-implto.cod-eqpto AT ROW 6 COL 18 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 16 BY .88
     fiDescImplto AT ROW 6 COL 34 COLON-ALIGNED NO-LABEL
     btOK AT ROW 7.83 COL 2
     btSave AT ROW 7.83 COL 13
     btCancel AT ROW 7.83 COL 24
     btHelp AT ROW 7.83 COL 80
     rtKeys AT ROW 1 COL 1
     rtKeys-2 AT ROW 3.5 COL 1
     rtToolBar AT ROW 7.58 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 90 BY 8.17
         FONT 1.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: MaintenanceNoNavigation
   Allow: Basic,Browse,DB-Fields,Window,Query
   Add Fields to: Neither
   Other Settings: COMPILE
   Temp-Tables and Buffers:
      TABLE: ttmab-eqpto T "?" NO-UNDO mgfro mab-eqpto
      ADDITIONAL-FIELDS:
          FIELD R-ROWID AS ROWID
      END-FIELDS.
      TABLE: ttmgf-eqpto-implto T "?" NO-UNDO mgfro mgf-eqpto-implto
      ADDITIONAL-FIELDS:
          FIELD R-ROWID AS ROWID
      END-FIELDS.
   END-TABLES.
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW wMaintenanceNoNavigation ASSIGN
         HIDDEN             = YES
         TITLE              = "Relacionamento Implemento X Equipamento"
         HEIGHT             = 8.17
         WIDTH              = 89.86
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
ON END-ERROR OF wMaintenanceNoNavigation /* Relacionamento Implemento X Equipamento */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wMaintenanceNoNavigation wMaintenanceNoNavigation
ON WINDOW-CLOSE OF wMaintenanceNoNavigation /* Relacionamento Implemento X Equipamento */
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
        
  

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME ttmgf-eqpto-implto.cod-eqpto
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ttmgf-eqpto-implto.cod-eqpto wMaintenanceNoNavigation
ON F5 OF ttmgf-eqpto-implto.cod-eqpto IN FRAME fpage0 /* Equipamento */
DO:
    assign lImplto = no
           lEqpto  = no.
   {method/zoomfields.i                                                
     &ProgramZoom="frzoom~\z01fr007.w"                                  
     &FieldZoom1="cod-eqpto"                                           
     &FieldScreen1="ttmgf-eqpto-implto.cod-eqpto"                       
     &Frame1="fPage0"                                                  
     &EnableImplant="YES"}                                             

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ttmgf-eqpto-implto.cod-eqpto wMaintenanceNoNavigation
ON LEAVE OF ttmgf-eqpto-implto.cod-eqpto IN FRAME fpage0 /* Equipamento */
DO:
     def var cDesc as char no-undo. 
&IF "{&mguni_version}" >= "2.071" &THEN
     def var iEmp  LIKE empresa.ep-codigo no-undo.
&else
     def var iEmp  as int no-undo.
&endif

       run buscaRegistro in {&hDBOTable} (input input frame fPage0 ttmgf-eqpto-implto.cod-eqpto, 
                                         output iEmp).  

        run buscaEmpresa in {&hDBOTable} (input iEmp,
                                         output cDesc).


       assign fiEmpImplto                        = cDesc
              ttmgf-eqpto-implto.ep-codigo-eqpto = iEmp.

       disp  fiEmpImplto                       
             ttmgf-eqpto-implto.ep-codigo-eqpto with frame fPage0.                                                                     
                                               
    RUN buscaModelo in {&hDBOTable} ( input input frame fPage0 ttmgf-eqpto-implto.ep-codigo-eqpto,
                                      input input frame fPage0 ttmgf-eqpto-implto.cod-eqpto,
                                      output cDescModel).

     assign fiDescImplto:screen-value in frame fPage0 = cDescModel.
      

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ttmgf-eqpto-implto.cod-eqpto wMaintenanceNoNavigation
ON MOUSE-SELECT-DBLCLICK OF ttmgf-eqpto-implto.cod-eqpto IN FRAME fpage0 /* Equipamento */
DO:
  apply "F5":U to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME ttmab-eqpto.cod-eqpto
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ttmab-eqpto.cod-eqpto wMaintenanceNoNavigation
ON LEAVE OF ttmab-eqpto.cod-eqpto IN FRAME fpage0 /* Equipamento */
DO:
   if avail TTmab-eqpto then do:
        {method\referenceFields.i
            &HandleDBOLeave="hDBOModelo"
            &KeyValue1="TTmab-eqpto.cod-model"
            &FieldName1="des-model"
            &FieldScreen1="fiDescEqpto"
            &Frame1="fPage0"}
    end.
    else
        assign fiDescEqpto:screen-value in frame fPage0 = "":U.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME ttmab-eqpto.ep-codigo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ttmab-eqpto.ep-codigo wMaintenanceNoNavigation
ON LEAVE OF ttmab-eqpto.ep-codigo IN FRAME fpage0 /* Empresa */
DO:
    def var cDesc as char no-undo.
   if avail TTmab-eqpto then do:
         run buscaEmpresa in {&hDBOTable} (input input frame fPage0 TTmab-eqpto.ep-codigo,
                                            output cDesc).
         assign fiEmpEqpto:screen-value in frame fPage0 = cDesc. 

   end.
   else do:
       assign fiEmpEqpto:screen-value in frame fPage0 = "":U.
   end.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME ttmgf-eqpto-implto.ep-codigo-eqpto
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ttmgf-eqpto-implto.ep-codigo-eqpto wMaintenanceNoNavigation
ON F5 OF ttmgf-eqpto-implto.ep-codigo-eqpto IN FRAME fpage0 /* Empresa */
DO:
  {include/zoomvar.i &prog-zoom=adzoom/z01ad101.w
                     &campo=ttmgf-eqpto-implto.ep-codigo-eqpto
                     &campozoom=ep-codigo
                     &frame=fPage0}  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ttmgf-eqpto-implto.ep-codigo-eqpto wMaintenanceNoNavigation
ON LEAVE OF ttmgf-eqpto-implto.ep-codigo-eqpto IN FRAME fpage0 /* Empresa */
DO:
    def var cDesc as char no-undo.
      run buscaEmpresa in {&hDBOTable} (input input frame fPage0 ttmgf-eqpto-implto.ep-codigo-eqpto,
                                        output cDesc).
      assign fiEmpImplto:screen-value in frame fPage0 = cDesc. 

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ttmgf-eqpto-implto.ep-codigo-eqpto wMaintenanceNoNavigation
ON MOUSE-SELECT-DBLCLICK OF ttmgf-eqpto-implto.ep-codigo-eqpto IN FRAME fpage0 /* Empresa */
DO:
   apply "F5":U to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wMaintenanceNoNavigation 


ttmgf-eqpto-implto.ep-codigo-eqpto:load-mouse-pointer ("image/lupa.cur")  in frame fPage0.
ttmgf-eqpto-implto.cod-eqpto:load-mouse-pointer ("image/lupa.cur")  in frame fPage0.
/*--- L¢gica para inicializa‡Æo do programam ---*/
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
/** Modelo **/
if valid-handle(hDBOEqpto) then
    run destroy in hDBOEqpto.


/** Modelo **/
if valid-handle(hDBOModelo) then
    run destroy in hDBOModelo.

{method/showmessage.i3}



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
/** Descri‡Æo Modelo - Implemento**/
apply "LEAVE":U to {&ttParent}.cod-eqpto in frame fPage0.

/** Descri‡Æo Empresa - Implemento **/
apply "LEAVE":U to {&ttParent}.ep-codigo in frame fPage0.


if pcAction =  "Update":U then do:
    assign {&ttTable}.dat-inicial:sensitive in frame fPage0 = no
           {&ttTable}.cod-eqpto:sensitive in frame fPage0 = yes
           {&ttTable}.ep-codigo-eqpto:sensitive in frame fPage0 = yes
           {&ttTable}.dat-final:sensitive in frame fPage0 = yes.

    /** Descri‡Æo Modelo - Equipamento**/
    apply "LEAVE":U to {&ttTable}.cod-eqpto in frame fPage0.

    /** Descri‡Æo Empresa - Equipamento **/
    apply "LEAVE":U to {&ttTable}.ep-codigo-eqpto in frame fPage0.
end.

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

/**Label do Implemento***/
{utp/ut-liter.i "Implemento" MAB}
assign {&ttParent}.cod-eqpto:label in frame fPage0 = return-value.


/** Descri‡Æo Modelo - Implemento**/
apply "LEAVE":U to {&ttParent}.cod-eqpto in frame fPage0.

/** Descri‡Æo Empresa - Implemento **/
apply "LEAVE":U to {&ttParent}.ep-codigo in frame fPage0.

   
return "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE beforeInitializeInterface wMaintenanceNoNavigation 
PROCEDURE beforeInitializeInterface :
/*------------------------------------------------------------------------------
  Purpose:     beforeInitializeInterface
  Parameters:  <none>
  Notes:       Override (antes) da inicializa‡Æo de tela
------------------------------------------------------------------------------*/
/** Inicializa as BOs das chaves estrangeiras **/

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
  
     /*--- DBO Modelo ---*/
    IF NOT VALID-HANDLE(hDBOModelo) OR
       hDBOModelo:TYPE <> "PROCEDURE":U OR
       hDBOModelo:FILE-NAME <> "frbo~\bofr016.p":U THEN DO:
        run frbo/bofr016.p persistent set  hDBOModelo.
    END.
    
    RUN openQueryStatic IN hDBOModelo (INPUT "Main":U) NO-ERROR.


 RETURN "ok":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE saveParentFields wMaintenanceNoNavigation 
PROCEDURE saveParentFields :
/*------------------------------------------------------------------------------
  Purpose:     Salva valores dos campos da tabela filho ({&ttTable}) com base 
               nos campos da tabela pai ({&ttParent})
  Parameters:  
  Notes:       Este m‚todo somente ‚ executado quando a vari vel pcAction 
               possuir os valores ADD ou COPY
------------------------------------------------------------------------------*/

assign {&ttTable}.ep-codigo-implto  = {&ttParent}.ep-codigo
       {&ttTable}.cod-implto        = {&ttParent}.cod-eqpto.


RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

