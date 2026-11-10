&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          movfro           PROGRESS
*/
&Scoped-define WINDOW-NAME wMaintenanceNoNavigation


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE TTmab-viagem NO-UNDO LIKE mab-viagem
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
{include/i-prgvrs.i AB0304A 2.00.00.006 } /*** 010006 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i ab0304a MAB}
&ENDIF



CREATE WIDGET-POOL.

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program           AB0304A
&GLOBAL-DEFINE Version        2.00.00.006

&GLOBAL-DEFINE Folder           NO
&GLOBAL-DEFINE InitialPage      

&GLOBAL-DEFINE FolderLabels      

&GLOBAL-DEFINE ttTable           TTmab-viagem
&GLOBAL-DEFINE hDBOTable         hDBOViagem
&GLOBAL-DEFINE DBOTable          mab-viagem


&GLOBAL-DEFINE page0KeyFields   TTmab-viagem.num-viagem
                                
&GLOBAL-DEFINE page0Fields      TTmab-viagem.ep-codigo ~
                                TTmab-viagem.cod-eqpto ~
                                TTmab-viagem.cod-rota ~
                                TTmab-viagem.dat-saida ~
                                TTmab-viagem.dat-ret ~
                                TTmab-viagem.hra-ret ~
                                TTmab-viagem.hra-saida ~
                                TTmab-viagem.num-reserva ~
                                TTmab-viagem.val-hodom-horim-final ~
                                TTmab-viagem.val-hodom-horim-inicial ~
                                TTmab-viagem.cod-usuar ~
                                TTmab-viagem.dat-atualiz ~
                                TTmab-viagem.ep-codigo-matr ~
                                TTmab-viagem.cod-estabel-matr ~
                                TTmab-viagem.cod-matr ~
                                TTmab-viagem.dsl-obs


&GLOBAL-DEFINE page1Fields       

/* Global Shared Variable Definitions ---                               */
DEFINE NEW GLOBAL SHARED VARIABLE adm-broker-hdl AS HANDLE NO-UNDO.
/* Parameters Definitions ---                                           */
DEFINE INPUT PARAMETER prTable         AS ROWID     NO-UNDO.
DEFINE INPUT PARAMETER pcAction        AS CHARACTER NO-UNDO.
DEFINE INPUT PARAMETER phCaller        AS HANDLE    NO-UNDO.
/* Local Variable Definitions ---                                       */
DEFINE VARIABLE cHora       AS CHARACTER format "00:00:00" NO-UNDO.
DEFINE VARIABLE cHora2      AS CHARACTER format "00:00:00" NO-UNDO.
DEFINE VARIABLE HoraInvIni  AS DEC  NO-UNDO.
DEFINE VARIABLE HoraInvFim  AS DEC  NO-UNDO.
/* Local Variable Definitions (DBOs Handles) --- */
DEFINE VARIABLE {&hDBOTable}       AS HANDLE NO-UNDO.
DEFINE VARIABLE hDBOTrajeto        AS HANDLE     NO-UNDO.
DEFINE VARIABLE hDBOMotorista      AS HANDLE     NO-UNDO.
DEFINE VARIABLE hDBOReserva        AS HANDLE     NO-UNDO.
DEFINE VARIABLE wh-pesquisa        AS HANDLE     NO-UNDO.
{abp/ab9000.i} /** Procedures de convers∆o de tempo:
                   piFormataHoraParaSegundo
                   piFormataSegundoParaHora **/

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE wMaintenanceNoNavigation
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fpage0

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS TTmab-viagem.dat-saida TTmab-viagem.hra-saida ~
TTmab-viagem.dat-ret TTmab-viagem.hra-ret ~
TTmab-viagem.val-hodom-horim-inicial TTmab-viagem.val-hodom-horim-final ~
TTmab-viagem.num-reserva TTmab-viagem.dat-atualiz TTmab-viagem.num-viagem ~
TTmab-viagem.cod-usuar TTmab-viagem.cod-rota TTmab-viagem.ep-codigo ~
TTmab-viagem.cod-eqpto TTmab-viagem.ep-codigo-matr ~
TTmab-viagem.cod-estabel-matr TTmab-viagem.cod-matr TTmab-viagem.dsl-obs 
&Scoped-define ENABLED-TABLES TTmab-viagem
&Scoped-define FIRST-ENABLED-TABLE TTmab-viagem
&Scoped-Define ENABLED-OBJECTS cDescLocaL cDescEmp cDescEqpto cNomeMot btOK ~
btSave btCancel btHelp RECT-31 RECT-33 RECT-34 RECT-35 RECT-36 rtKeys ~
rtToolBar 
&Scoped-Define DISPLAYED-FIELDS TTmab-viagem.dat-saida ~
TTmab-viagem.hra-saida TTmab-viagem.dat-ret TTmab-viagem.hra-ret ~
TTmab-viagem.val-hodom-horim-inicial TTmab-viagem.val-hodom-horim-final ~
TTmab-viagem.num-reserva TTmab-viagem.dat-atualiz TTmab-viagem.num-viagem ~
TTmab-viagem.cod-usuar TTmab-viagem.cod-rota TTmab-viagem.ep-codigo ~
TTmab-viagem.cod-eqpto TTmab-viagem.ep-codigo-matr ~
TTmab-viagem.cod-estabel-matr TTmab-viagem.cod-matr TTmab-viagem.dsl-obs 
&Scoped-define DISPLAYED-TABLES TTmab-viagem
&Scoped-define FIRST-DISPLAYED-TABLE TTmab-viagem
&Scoped-Define DISPLAYED-OBJECTS cDescLocaL cDescEmp cDescEqpto cNomeMot 

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

DEFINE VARIABLE cDescEmp AS CHARACTER FORMAT "X(30)":U 
     VIEW-AS FILL-IN 
     SIZE 42.86 BY .88 NO-UNDO.

DEFINE VARIABLE cDescEqpto AS CHARACTER FORMAT "X(30)":U 
     VIEW-AS FILL-IN 
     SIZE 32 BY .88 NO-UNDO.

DEFINE VARIABLE cDescLocaL AS CHARACTER FORMAT "X(30)":U 
     VIEW-AS FILL-IN 
     SIZE 36 BY .88 NO-UNDO.

DEFINE VARIABLE cNomeMot AS CHARACTER FORMAT "X(30)":U 
     VIEW-AS FILL-IN 
     SIZE 36 BY .88 NO-UNDO.

DEFINE RECTANGLE RECT-31
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 85 BY 5.5.

DEFINE RECTANGLE RECT-33
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 20 BY 2.75.

DEFINE RECTANGLE RECT-34
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 20 BY 2.75.

DEFINE RECTANGLE RECT-35
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 20 BY 2.75.

DEFINE RECTANGLE RECT-36
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 23 BY 2.75.

DEFINE RECTANGLE rtKeys
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 89 BY 1.5.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 90 BY 1.42
     BGCOLOR 7 .


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fpage0
     TTmab-viagem.dat-saida AT ROW 3.42 COL 8.86 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 10 BY .88
     TTmab-viagem.hra-saida AT ROW 4.42 COL 8.86 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 10 BY .88
     TTmab-viagem.dat-ret AT ROW 3.42 COL 30.14 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 10 BY .88
     TTmab-viagem.hra-ret AT ROW 4.42 COL 30.14 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 10 BY .88
     TTmab-viagem.val-hodom-horim-inicial AT ROW 3.42 COL 51.57 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 10 BY .88
     TTmab-viagem.val-hodom-horim-final AT ROW 4.42 COL 51.57 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 10 BY .88
     TTmab-viagem.num-reserva AT ROW 5.92 COL 19 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 12 BY .88
     TTmab-viagem.dat-atualiz AT ROW 4.42 COL 75.72 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 12 BY .88
     TTmab-viagem.num-viagem AT ROW 1.46 COL 32 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 10 BY .88
     TTmab-viagem.cod-usuar AT ROW 3.42 COL 75.72 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 12 BY .88
     TTmab-viagem.cod-rota AT ROW 6.92 COL 19 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 12 BY .88
     cDescLocaL AT ROW 6.92 COL 31 COLON-ALIGNED NO-LABEL
     TTmab-viagem.ep-codigo AT ROW 7.92 COL 19 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 5 BY .88
     cDescEmp AT ROW 7.92 COL 24.14 COLON-ALIGNED NO-LABEL
     TTmab-viagem.cod-eqpto AT ROW 8.92 COL 19 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 16 BY .88
     cDescEqpto AT ROW 8.92 COL 35 COLON-ALIGNED NO-LABEL
     TTmab-viagem.ep-codigo-matr AT ROW 9.92 COL 19.14 COLON-ALIGNED
          LABEL "Motorista":R9
          VIEW-AS FILL-IN 
          SIZE 5 BY .88
     TTmab-viagem.cod-estabel-matr AT ROW 9.92 COL 24.29 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 5 BY .88
     TTmab-viagem.cod-matr AT ROW 9.92 COL 29.43 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 12 BY .88
     cNomeMot AT ROW 9.92 COL 41.43 COLON-ALIGNED NO-LABEL
     TTmab-viagem.dsl-obs AT ROW 11.54 COL 8 NO-LABEL
          VIEW-AS EDITOR MAX-CHARS 2000 SCROLLBAR-VERTICAL
          SIZE 80 BY 4.71
     btOK AT ROW 16.79 COL 2
     btSave AT ROW 16.79 COL 13
     btCancel AT ROW 16.79 COL 24
     btHelp AT ROW 16.79 COL 80
     "Data:" VIEW-AS TEXT
          SIZE 4 BY .54 AT ROW 3.54 COL 6.43
     "Sa°da:" VIEW-AS TEXT
          SIZE 6 BY .54 AT ROW 2.71 COL 3
     "Retorno:" VIEW-AS TEXT
          SIZE 7 BY .54 AT ROW 2.67 COL 25.57
     "Contador" VIEW-AS TEXT
          SIZE 7.43 BY .54 AT ROW 2.67 COL 46.57
     "Trajeto:" VIEW-AS TEXT
          SIZE 5.43 BY .54 AT ROW 7.08 COL 15
     "Observaá∆o:" VIEW-AS TEXT
          SIZE 9.14 BY .54 AT ROW 10.75 COL 5.86
     "Documento Viagem:" VIEW-AS TEXT
          SIZE 14 BY .54 AT ROW 1.58 COL 19.57
     "Documento Reserva:" VIEW-AS TEXT
          SIZE 15 BY .54 AT ROW 6.08 COL 5.57
     "Inicial:" VIEW-AS TEXT
          SIZE 5 BY .54 AT ROW 3.58 COL 48.14
     "Final:" VIEW-AS TEXT
          SIZE 4.43 BY .54 AT ROW 4.58 COL 48.72
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 90 BY 17.17
         FONT 1.

/* DEFINE FRAME statement is approaching 4K Bytes.  Breaking it up   */
DEFINE FRAME fpage0
     RECT-31 AT ROW 11 COL 5
     RECT-33 AT ROW 2.96 COL 1.72
     RECT-34 AT ROW 2.96 COL 23.72
     RECT-35 AT ROW 2.96 COL 45.29
     RECT-36 AT ROW 2.96 COL 67.43
     rtKeys AT ROW 1.08 COL 1.57
     rtToolBar AT ROW 16.58 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 90 BY 17.17
         FONT 1.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: wMaintenanceNoNavigation
   Allow: Basic,Browse,DB-Fields,Window,Query
   Add Fields to: Neither
   Temp-Tables and Buffers:
      TABLE: TTmab-viagem T "?" NO-UNDO movfro mab-viagem
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
         TITLE              = "Manutená∆o de Viagem"
         HEIGHT             = 17.21
         WIDTH              = 90
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
   FRAME-NAME Custom                                                    */
/* SETTINGS FOR FILL-IN TTmab-viagem.ep-codigo-matr IN FRAME fpage0
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
ON END-ERROR OF wMaintenanceNoNavigation /* Manutená∆o de Viagem */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wMaintenanceNoNavigation wMaintenanceNoNavigation
ON WINDOW-CLOSE OF wMaintenanceNoNavigation /* Manutená∆o de Viagem */
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
    DEFINE VARIABLE cTexto AS CHARACTER  NO-UNDO.

     

    if  can-find ( first mab-reserva
                  where mab-reserva.num-reserva = INPUT FRAME fPage0 TTmab-viagem.num-reserva
                  AND mab-reserva.val-dat-hora-invrtda-inic > TTmab-viagem.val-dat-hora-invrtda-inic ) then do:
                 {utp~/ut-liter.i "Data e Hora"} 
                 ASSIGN cTexto = RETURN-VALUE.
                 run utp/ut-msgs.p (input "show":U,
                                    input 28608,
                                    INPUT cTexto).
                    
    end.
    IF INPUT FRAME fPage0 TTmab-viagem.num-reserva = 0  THEN DO:
       IF TTmab-viagem.val-dat-hora-invrtda-final <> 0 THEN DO:
          FOR first mab-reserva
              where mab-reserva.num-reserva                   <> 0
              AND   mab-reserva.ep-codigo                     = INPUT FRAME fPage0 TTmab-viagem.ep-codigo
              AND   mab-reserva.cod-eqpto                     = INPUT FRAME fPage0 TTmab-viagem.cod-eqpto        
              AND   mab-reserva.val-dat-hora-invrtda-inic     < TTmab-viagem.val-dat-hora-invrtda-final 
              AND   mab-reserva.val-dat-hora-invrtda-final    > TTmab-viagem.val-dat-hora-invrtda-final NO-LOCK: 
              {utp~/ut-liter.i "Equipamento j† possui reserva para o periodo informado" }
              ASSIGN cTexto = RETURN-VALUE.
              {utp~/ut-liter.i "Equipamento j† possui reserva para o periodo" }
              run utp/ut-msgs.p (input "show":U,
                                 input 17242,
                                 INPUT return-value + '~~~~' + cTexto).
          end.
       END.
    end.

   /** Salva Registro **/
    RUN saveRecord IN THIS-PROCEDURE.
    IF RETURN-VALUE = "OK":U THEN
        APPLY "CLOSE":U TO THIS-PROCEDURE.
    else do:
        if pcAction <> "UPDATE":U then do:
            /** Busca a numeraá∆o da Viagem, pois pode ter sido 
            inclu°do um outro registro durante este erro **/
         run buscaNrViagem in {&hDBOTable} (output {&ttTable}.num-viagem).
            /** Mostra documento em tela **/
            display {&ttTable}.num-viagem
                with frame fPage0.
            return no-apply.
        end.
    end.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btSave
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btSave wMaintenanceNoNavigation
ON CHOOSE OF btSave IN FRAME fpage0 /* Salvar */
DO:
       /** Salva Registro **/
    RUN saveRecord IN THIS-PROCEDURE.
    if pcAction <> "UPDATE":U then do:
        /** Busca a numeraá∆o da Viagem, pois pode ter sido 
            inclu°do um outro registro durante este erro **/
         run buscaNrViagem in {&hDBOTable} (output {&ttTable}.num-viagem).
        /** Mostra documento em tela **/
        display {&ttTable}.num-viagem
            with frame fPage0.
        return no-apply.
    end. 
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME TTmab-viagem.cod-eqpto
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL TTmab-viagem.cod-eqpto wMaintenanceNoNavigation
ON LEAVE OF TTmab-viagem.cod-eqpto IN FRAME fpage0 /* Equipamento */
DO:
    ASSIGN cDescEqpto = "".
    DISP cDescEqpto WITH FRAME fPage0. 

    FOR FIRST mab-eqpto FIELDS (ep-codigo cod-eqpto cod-model)
        WHERE mab-eqpto.ep-codigo = INPUT FRAME fPage0 TTmab-viagem.ep-codigo
        AND   mab-eqpto.cod-eqpto = INPUT FRAME fPage0 TTmab-viagem.cod-eqpto,
        EACH mab-model FIELDS (cod-model des-model)
        WHERE mab-model.cod-model = mab-eqpto.cod-model NO-LOCK:
            ASSIGN cDescEqpto = mab-model.des-model.
            DISP cDescEqpto WITH FRAME fPage0. 
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL TTmab-viagem.cod-eqpto wMaintenanceNoNavigation
ON MOUSE-SELECT-DBLCLICK OF TTmab-viagem.cod-eqpto IN FRAME fpage0 /* Equipamento */
OR f5 OF TTmab-viagem.cod-eqpto IN FRAME fPage0 DO:
    {method/zoomfields.i 
       &ProgramZoom="frzoom/z01fr007.w"
       &FieldZoom1="cod-eqpto"
       &FieldScreen1="{&ttTable}.cod-eqpto"
       &Frame1="fPage0"
       &FieldZoom2="ep-codigo"
       &FieldScreen2="{&ttTable}.ep-codigo"
       &Frame2="fPage0"
       &EnableImplant="YES"}
       
    WAIT-FOR "CLOSE":U OF hProgramZoom.
    APPLY "LEAVE":U TO TTmab-viagem.cod-eqpto IN FRAME fPage0. 
    APPLY "LEAVE":U TO TTmab-viagem.ep-codigo IN FRAME fPage0. 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME TTmab-viagem.cod-estabel-matr
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL TTmab-viagem.cod-estabel-matr wMaintenanceNoNavigation
ON F5 OF TTmab-viagem.cod-estabel-matr IN FRAME fpage0 /* cod-estabel-matr */
DO:
  APPLY "F5":U TO TTmab-viagem.cod-matr IN FRAME fpage0.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL TTmab-viagem.cod-estabel-matr wMaintenanceNoNavigation
ON MOUSE-SELECT-DBLCLICK OF TTmab-viagem.cod-estabel-matr IN FRAME fpage0 /* cod-estabel-matr */
DO:
  APPLY "F5":U TO TTmab-viagem.cod-matr IN FRAME fpage0.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME TTmab-viagem.cod-matr
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL TTmab-viagem.cod-matr wMaintenanceNoNavigation
ON F5 OF TTmab-viagem.cod-matr IN FRAME fpage0 /* cod-matr */
DO:
      {method/zoomfields.i 
           &ProgramZoom="frzoom~\z01fr017.w"
           &FieldZoom1="ep-codigo"
           &FieldScreen1="TTmab-viagem.ep-codigo-matr"
           &Frame1="fPage0"
           &FieldZoom2="cod-estabel"
           &FieldScreen2="TTmab-viagem.cod-estabel-matr"
           &Frame2="fPage0"
           &FieldZoom3="cod-matr"
           &FieldScreen3="TTmab-viagem.cod-matr"
           &Frame3="fPage0"
           &FieldZoom4="nom-motoris"
           &FieldScreen4="cNomeMot"
           &Frame4="fPage0"
           &EnableImplant="YES"}  
           
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL TTmab-viagem.cod-matr wMaintenanceNoNavigation
ON LEAVE OF TTmab-viagem.cod-matr IN FRAME fpage0 /* cod-matr */
DO:
      for first mab-param
          where mab-param.cdn-param = 52 no-lock:
          if mab-param.des-valor = "1":U then do:
              IF  INPUT FRAME fPage0 TTmab-viagem.ep-codigo-matr = "" OR INPUT FRAME fPage0 TTmab-viagem.cod-estabel-matr = "" THEN DO:
                  for first mab-motoris
                      where mab-motoris.cod-matr = TTmab-viagem.cod-matr:screen-value in frame fPage0 no-lock:
                      assign TTmab-viagem.ep-codigo-matr:screen-value in frame fPage0 = mab-motoris.ep-codigo
                             TTmab-viagem.cod-estabel-matr:screen-value in frame fPage0 = mab-motoris.cod-estabel.
                  end.
                  if not avail mab-motoris then do:
                      assign TTmab-viagem.ep-codigo-matr:screen-value in frame fPage0 = ""
                             TTmab-viagem.cod-estabel-matr:screen-value in frame fPage0 = "".
                  end.
              END.
          end.
      end.
      {method/ReferenceFields.i
      &HandleDBOLeave="hDBOMotorista"
      &KeyValue1="input frame fPage0 TTmab-viagem.ep-codigo-matr"
      &KeyValue2="input frame fPage0 TTmab-viagem.cod-estabel-matr"
      &KeyValue3="input frame fPage0 TTmab-viagem.cod-matr"
      &FieldName1="nom-motoris"
      &FieldScreen1="cNomeMot"
      &Frame1="fPage0"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL TTmab-viagem.cod-matr wMaintenanceNoNavigation
ON MOUSE-SELECT-DBLCLICK OF TTmab-viagem.cod-matr IN FRAME fpage0 /* cod-matr */
DO:
   apply "F5":U to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME TTmab-viagem.cod-rota
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL TTmab-viagem.cod-rota wMaintenanceNoNavigation
ON F5 OF TTmab-viagem.cod-rota IN FRAME fpage0 /* cod-rota */
DO:
   {method/zoomfields.i 
           &ProgramZoom="frzoom~\z01fr028.w"
           &FieldZoom1="cod-rota"
           &FieldScreen1="TTmab-viagem.cod-rota"
           &Frame1="fPage0"
           &FieldZoom2="des-trajeto"
           &FieldScreen2="cDescLocaL"
           &Frame2="fPage0"
           &EnableImplant="YES"} 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL TTmab-viagem.cod-rota wMaintenanceNoNavigation
ON LEAVE OF TTmab-viagem.cod-rota IN FRAME fpage0 /* cod-rota */
DO:
   {method~/referencefields.i
            &HandleDBOLeave="hDBOTrajeto"
            &KeyValue1="TTmab-viagem.cod-rota:screen-value in frame fPage0"
            &FieldName1="des-trajeto"
            &FieldScreen1="cDescLocal"
            &Frame1="fPage0"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL TTmab-viagem.cod-rota wMaintenanceNoNavigation
ON MOUSE-SELECT-DBLCLICK OF TTmab-viagem.cod-rota IN FRAME fpage0 /* cod-rota */
DO:
  apply "F5":U to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME TTmab-viagem.dat-ret
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL TTmab-viagem.dat-ret wMaintenanceNoNavigation
ON LEAVE OF TTmab-viagem.dat-ret IN FRAME fpage0 /* Data */
DO:
  IF TTmab-viagem.dat-ret:SCREEN-VALUE IN FRAME fPage0 = "" THEN DO:
      ASSIGN TTmab-viagem.dat-ret = ?.
      DISPLAY TTmab-viagem.dat-ret WITH FRAME fPage0.
  END.
  ELSE DO:
  END.
    
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME TTmab-viagem.ep-codigo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL TTmab-viagem.ep-codigo wMaintenanceNoNavigation
ON LEAVE OF TTmab-viagem.ep-codigo IN FRAME fpage0 /* Empresa */
DO:
    FIND FIRST empresa WHERE empresa.ep-codigo = INPUT FRAME fPage0 TTmab-viagem.ep-codigo NO-LOCK NO-ERROR.
    IF AVAIL empresa THEN DO:
        ASSIGN cDescEmp = empresa.razao-social.
        DISP cDescEmp WITH FRAME fPage0.
    END.
    ELSE DO:
        ASSIGN cDescEmp = "".
        DISP cDescEmp WITH FRAME fPage0.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL TTmab-viagem.ep-codigo wMaintenanceNoNavigation
ON MOUSE-SELECT-DBLCLICK OF TTmab-viagem.ep-codigo IN FRAME fpage0 /* Empresa */
OR f5 OF TTmab-viagem.ep-codigo IN FRAME fPage0 DO:

{include/zoomvar.i &prog-zoom="adzoom/z01ad101.w"
                       &campo=TTmab-viagem.ep-codigo
                       &campozoom=ep-codigo
                       &campo2=cDescEmp
                       &campozoom2=razao-social}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME TTmab-viagem.ep-codigo-matr
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL TTmab-viagem.ep-codigo-matr wMaintenanceNoNavigation
ON F5 OF TTmab-viagem.ep-codigo-matr IN FRAME fpage0 /* Motorista */
DO:
  APPLY "F5":U TO TTmab-viagem.cod-matr IN FRAME fpage0.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL TTmab-viagem.ep-codigo-matr wMaintenanceNoNavigation
ON MOUSE-SELECT-DBLCLICK OF TTmab-viagem.ep-codigo-matr IN FRAME fpage0 /* Motorista */
DO:
  APPLY "F5":U TO TTmab-viagem.cod-matr IN FRAME fpage0.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME TTmab-viagem.hra-ret
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL TTmab-viagem.hra-ret wMaintenanceNoNavigation
ON LEAVE OF TTmab-viagem.hra-ret IN FRAME fpage0 /* Hora */
DO:
    assign cHora2 = TTmab-viagem.hra-ret:screen-value in frame fPage0.
     run piFormataHorarioSeg (input-output cHora2).
     if return-value = "NOK":U then do:
         apply "ENTRY":U to TTmab-viagem.hra-ret in frame fPage0.
         return no-apply.
     end.
     assign TTmab-viagem.hra-ret:screen-value in frame fPage0 = cHora2.    

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME TTmab-viagem.hra-saida
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL TTmab-viagem.hra-saida wMaintenanceNoNavigation
ON LEAVE OF TTmab-viagem.hra-saida IN FRAME fpage0 /* Hora */
DO:
    assign cHora = TTmab-viagem.hra-saida:screen-value in frame fPage0.
     run piFormataHorarioSeg (input-output cHora).
     if return-value = "NOK":U then do:
         apply "ENTRY":U to TTmab-viagem.hra-saida in frame fPage0.
         return no-apply.
     end.
     assign TTmab-viagem.hra-saida:screen-value in frame fPage0 = cHora.    

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME TTmab-viagem.num-reserva
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL TTmab-viagem.num-reserva wMaintenanceNoNavigation
ON F5 OF TTmab-viagem.num-reserva IN FRAME fpage0 /* num-reserva */
DO:
    {method/zoomfields.i 
        &ProgramZoom="frzoom~\z01fr062.w"
        &FieldZoom1="num-reserva"
        &FieldScreen1="TTmab-viagem.num-reserva"
        &Frame1="fPage0"
        &FieldZoom2="cod-rota-dest"
        &FieldScreen2="TTmab-viagem.cod-rota"
        &Frame2="fPage0"
        &FieldZoom3="ep-codigo"
        &FieldScreen3="TTmab-viagem.ep-codigo"
        &Frame3="fPage0"
        &FieldZoom4="cod-eqpto"
        &FieldScreen4="TTmab-viagem.cod-eqpto"
        &Frame4="fPage0"
        &FieldZoom5="cod-matr"
        &FieldScreen5="TTmab-viagem.cod-matr"
        &Frame5="fPage0"
        &FieldZoom6="dsl-obs"
        &FieldScreen6="TTmab-viagem.dsl-obs"
        &Frame6="fPage0"
        &EnableImplant="YES"} 
        
        wait-for "CLOSE":U of hProgramZoom.
        apply "LEAVE":U to TTmab-viagem.num-reserva in frame fPage0. 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL TTmab-viagem.num-reserva wMaintenanceNoNavigation
ON LEAVE OF TTmab-viagem.num-reserva IN FRAME fpage0 /* num-reserva */
DO:
    FOR FIRST mab-reserva FIELDS (num-reserva cod-rota-dest ep-codigo cod-eqpto cod-matr dsl-obs ep-codigo-matr cod-estabel-matr) 
        WHERE mab-reserva.num-reserva = INPUT FRAME fPage0 TTmab-viagem.num-reserva NO-LOCK:

        ASSIGN TTmab-viagem.num-reserva = mab-reserva.num-reserva    
               TTmab-viagem.cod-rota    = mab-reserva.cod-rota-dest
               TTmab-viagem.ep-codigo   = mab-reserva.ep-codigo
               TTmab-viagem.cod-eqpto   = mab-reserva.cod-eqpto 
               TTmab-viagem.ep-codigo-matr   = mab-reserva.ep-codigo-matr
               TTmab-viagem.cod-estabel-matr = mab-reserva.cod-estabel-matr
               TTmab-viagem.cod-matr    = mab-reserva.cod-matr
               TTmab-viagem.dsl-obs     = mab-reserva.dsl-obs.
 
        DISP TTmab-viagem.num-reserva 
             TTmab-viagem.cod-rota
             TTmab-viagem.ep-codigo  
             TTmab-viagem.cod-eqpto  
             TTmab-viagem.ep-codigo-matr
             TTmab-viagem.cod-estabel-matr
             TTmab-viagem.cod-matr   
             TTmab-viagem.dsl-obs WITH FRAME fPage0.
 
        APPLY "leave":U TO TTmab-viagem.num-reserva IN FRAME fPage0.
        APPLY "leave":U TO TTmab-viagem.cod-rota    IN FRAME fPage0.
        APPLY "leave":U TO TTmab-viagem.ep-codigo   IN FRAME fPage0.
        APPLY "leave":U TO TTmab-viagem.cod-eqpto   IN FRAME fPage0.
        APPLY "leave":U TO TTmab-viagem.cod-matr    IN FRAME fPage0.
        APPLY "leave":U TO TTmab-viagem.dsl-obs     IN FRAME fPage0.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL TTmab-viagem.num-reserva wMaintenanceNoNavigation
ON MOUSE-SELECT-DBLCLICK OF TTmab-viagem.num-reserva IN FRAME fpage0 /* num-reserva */
DO:
  apply "F5":U to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wMaintenanceNoNavigation 


TTmab-viagem.ep-codigo:load-mouse-pointer ("image/lupa.cur") in frame fPage0.
TTmab-viagem.cod-eqpto:load-mouse-pointer ("image/lupa.cur") in frame fPage0.
TTmab-viagem.ep-codigo-matr:load-mouse-pointer ("image/lupa.cur") in frame fPage0.
TTmab-viagem.cod-estabel-matr:load-mouse-pointer ("image/lupa.cur") in frame fPage0.
TTmab-viagem.cod-matr:load-mouse-pointer ("image/lupa.cur") in frame fPage0.
TTmab-viagem.cod-rota:load-mouse-pointer ("image/lupa.cur") in frame fPage0.
TTmab-viagem.num-reserva:load-mouse-pointer ("image/lupa.cur") in frame fPage0.
/*--- L¢gica para inicializaá∆o do programam ---*/
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
IF VALID-HANDLE (hDBOTrajeto) THEN
       RUN destroy IN hDBOTrajeto.

IF VALID-HANDLE (hDBOMotorista) THEN
       RUN destroy IN hDBOMotorista.

IF VALID-HANDLE (hDBOReserva) THEN
       RUN destroy IN hDBOReserva .




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


 IF pcAction = "ADD":U OR pcAction = "Update":U OR pcAction = "COPY":U THEN DO:
    apply "LEAVE":U to {&ttTable}.ep-codigo    in frame fPage0.
    apply "LEAVE":U to {&ttTable}.cod-eqpto     in frame fPage0.
    apply "LEAVE":U to {&ttTable}.cod-rota      in frame fPage0.
    apply "LEAVE":U to {&ttTable}.cod-matr      in frame fPage0.

    FOR FIRST mab-trajeto FIELDS (cod-rota des-rota) 
        WHERE mab-trajeto.cod-rota = INPUT FRAME fPage0 {&ttTable}.cod-rota NO-lock:
        
         ASSIGN cDescLocaL = mab-trajeto.des-rota.
         DISP cDescLocaL WITH FRAME fPage0.
   END.
 END.


 IF  pcAction <> "Update":U  THEN DO:

   
        /** Busca pr¢ximo n£mero da viagem automaticamente **/
        run buscaNrViagem in {&hDBOTable} (output {&ttTable}.num-viagem).

        /** Busca Usu†rio Corrente do EMS **/
        assign {&ttTable}.cod-usuar = c-seg-usuario.
         /** Data Atual **/
         assign {&ttTable}.dat-atualiz = today.
         /** Mostra Campos em tela **/
         display {&ttTable}.dat-atualiz
                 {&ttTable}.cod-usuar
             with frame fPage0.
        
     /** Mostra documento em tela **/
     display {&ttTable}.num-viagem
         with frame fPage0.

/*      ASSIGN {&ttTable}.dat-ret:SENSITIVE IN FRAME fPage0 = NO                */
/*             {&ttTable}.hra-ret:SENSITIVE IN FRAME fPage0 = NO                */
/*             {&ttTable}.val-hodom-horim-final:SENSITIVE IN FRAME fPage0 = NO. */
 
 END.
 ELSE DO:

     /** Desabilita campos em tela que n∆o s∆o atualizados pelo usu†rio **/
     disable {&ttTable}.cod-usuar
             {&ttTable}.num-viagem
             {&ttTable}.dat-atualiz
         with frame fPage0.
     
/*       ASSIGN {&ttTable}.dat-ret:SENSITIVE IN FRAME fPage0 = YES                */
/*              {&ttTable}.hra-ret:SENSITIVE IN FRAME fPage0 = YES                */
/*              {&ttTable}.val-hodom-horim-final:SENSITIVE IN FRAME fPage0 = YES  */
/*              {&ttTable}.dsl-obs:SENSITIVE IN FRAME fPage0 = YES                */
/*              {&ttTable}.dat-saida:SENSITIVE IN FRAME fPage0 = NO               */
/*              {&ttTable}.hra-saida:SENSITIVE IN FRAME fPage0 = NO               */
/*              {&ttTable}.num-reserva:SENSITIVE IN FRAME fPage0 = NO             */
/*              {&ttTable}.val-hodom-horim-inicial:SENSITIVE IN FRAME fPage0 = NO */
/*              {&ttTable}.cod-matr:SENSITIVE IN FRAME fPage0 = NO                */
/*              {&ttTable}.cod-eqpto:SENSITIVE IN FRAME fPage0 = NO               */
/*              {&ttTable}.cod-rota:SENSITIVE IN FRAME fPage0 = NO                */
/*              {&ttTable}.ep-codigo:SENSITIVE IN FRAME fPage0 = NO.              */

 END.


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
  /** Desabilita campos em tela que n∆o s∆o atualizados pelo usu†rio **/
     disable {&ttTable}.cod-usuar
             {&ttTable}.num-viagem
             {&ttTable}.dat-atualiz
         with frame fPage0.


FOR FIRST mab-trajeto FIELDS (cod-rota des-rota) 
    WHERE mab-trajeto.cod-rota = INPUT FRAME fPage0 TTmab-viagem.cod-rota NO-lock:
    ASSIGN cDescLocaL = mab-trajeto.des-rota.
    DISP cDescLocaL WITH FRAME fPage0.
 END.

for first mab-param
    where mab-param.cdn-param = 52 no-lock:
    if mab-param.des-valor = "1":U then do:
        assign TTmab-viagem.ep-codigo-matr:sensitive in frame fPage0 = no
               TTmab-viagem.cod-estabel-matr:sensitive in frame fPage0 = no.
    end.
    else do:
        assign TTmab-viagem.ep-codigo-matr:sensitive in frame fPage0 = yes
               TTmab-viagem.cod-estabel-matr:sensitive in frame fPage0 = yes.
    end.
end.


/*   IF  pcAction <> "Update":U  THEN DO:                                           */
/*                                                                                  */
/*      ASSIGN TTmab-viagem.dat-ret:SENSITIVE IN FRAME fPage0 = NO                  */
/*             TTmab-viagem.hra-ret:SENSITIVE IN FRAME fPage0 = NO                  */
/*             TTmab-viagem.val-hodom-horim-final:SENSITIVE IN FRAME fPage0 = NO.   */
/*                                                                                  */
/*  END.                                                                            */
/*  ELSE DO:                                                                        */
/*                                                                                  */
/*       ASSIGN TTmab-viagem.dat-ret:SENSITIVE IN FRAME fPage0 = YES                */
/*              TTmab-viagem.hra-ret:SENSITIVE IN FRAME fPage0 = YES                */
/*              TTmab-viagem.val-hodom-horim-final:SENSITIVE IN FRAME fPage0 = YES  */
/*              TTmab-viagem.dsl-obs:SENSITIVE IN FRAME fPage0 = YES                */
/*              TTmab-viagem.dat-saida:SENSITIVE IN FRAME fPage0 = NO               */
/*              TTmab-viagem.hra-saida:SENSITIVE IN FRAME fPage0 = NO               */
/*              TTmab-viagem.num-reserva:SENSITIVE IN FRAME fPage0 = NO             */
/*              TTmab-viagem.val-hodom-horim-inicial:SENSITIVE IN FRAME fPage0 = NO */
/*              TTmab-viagem.cod-matr:SENSITIVE IN FRAME fPage0 = NO                */
/*              TTmab-viagem.cod-eqpto:SENSITIVE IN FRAME fPage0 = NO               */
/*              TTmab-viagem.cod-rota:SENSITIVE IN FRAME fPage0 = NO                */
/*              TTmab-viagem.ep-codigo:SENSITIVE IN FRAME fPage0 = NO.              */
/*                                                                                  */
/*  END.                                                                            */
/*                                                                                  */


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
 IF  pcAction <> "Update":U  THEN DO:
      assign TTmab-viagem.hra-saida:screen-value in frame fPage0 = string(TIME,"HH:MM:SS").
 END.

 IF TTmab-viagem.dat-ret = ? THEN ASSIGN TTmab-viagem.dat-ret = ?.
 DISP TTmab-viagem.dat-ret WITH FRAME fPage0.

RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE beforeSaveFields wMaintenanceNoNavigation 
PROCEDURE beforeSaveFields :
/*------------------------------------------------------------------------------
  Purpose:     beforeSaveFields
  Parameters:  <none>
  Notes:       Override do mÇtodo padr∆o, salva valores antes do padr∆o na 
               temp-table
------------------------------------------------------------------------------*/

IF TTmab-viagem.dat-ret:SCREEN-VALUE IN FRAME fPage0 = "" THEN ASSIGN TTmab-viagem.dat-saida = ?.
/** Atualiza o campo hora invertida. Ser† gravado no 
    formato "AAAAMMDDHHMMSS" (Ano+Màs+Dia+Hora+Minuto+Segundo) **/
run converteParaHoraInvertidaInicial in {&hDBOTable} (input TTmab-viagem.dat-saida:screen-value in frame fPage0,
                                                      input TTmab-viagem.hra-saida:screen-value in frame fPage0,
                                                      output HoraInvIni ).

ASSIGN  TTmab-viagem.val-dat-hora-invrtda-inic  = HoraInvIni.

run converteParaHoraInvertidaFinal in {&hDBOTable} (input  TTmab-viagem.dat-ret:screen-value in frame fPage0,
                                                      input   TTmab-viagem.hra-ret:screen-value in frame fPage0,
                                                      output HoraInvFim).

ASSIGN    TTmab-viagem.val-dat-hora-invrtda-final   = HoraInvFim.






return "OK":U.
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

IF NOT VALID-HANDLE(hDBOTrajeto) OR 
         hDBOTrajeto:TYPE <> "PROCEDURE":U OR
         hDBOTrajeto:FILE-NAME <> "frbo~\bofr028.p":U THEN DO:
        RUN frbo~/bofr028.p PERSISTENT SET  hDBOTrajeto.
END.
RUN openQueryStatic in   hDBOTrajeto (input "Main":U) NO-ERROR.



IF NOT VALID-HANDLE(hDBOMotorista) OR 
         hDBOMotorista:TYPE <> "PROCEDURE":U OR
         hDBOMotorista:FILE-NAME <> "frbo~\bofr017.p":U THEN DO:
        RUN frbo~/bofr017.p PERSISTENT SET  hDBOMotorista.
END.
RUN openQueryStatic in   hDBOMotorista (input "Main":U) NO-ERROR.


IF NOT VALID-HANDLE(hDBOReserva) OR 
         hDBOReserva:TYPE <> "PROCEDURE":U OR
         hDBOReserva:FILE-NAME <> "frbo~\bofr062.p":U THEN DO:
        RUN frbo~/bofr062.p PERSISTENT SET  hDBOReserva.
END.
RUN openQueryStatic in   hDBOReserva (input "Main":U) NO-ERROR.

     
RETURN "OK":U.    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

