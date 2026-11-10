&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          movfro           PROGRESS
*/
&Scoped-define WINDOW-NAME wMaintenanceNoNavigation


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE TTmab-reserva NO-UNDO LIKE mab-reserva
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
{include/i-prgvrs.i AB0305A 2.00.00.004 } /*** 010004 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i ab0305a MAB}
&ENDIF



CREATE WIDGET-POOL.

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program           AB0305A
&GLOBAL-DEFINE Version        2.00.00.004

&GLOBAL-DEFINE Folder           NO
&GLOBAL-DEFINE InitialPage      

&GLOBAL-DEFINE FolderLabels      

&GLOBAL-DEFINE ttTable           TTmab-reserva
&GLOBAL-DEFINE hDBOTable         hDBOReserva
&GLOBAL-DEFINE DBOTable          mab-reserva


&GLOBAL-DEFINE page0KeyFields   TTmab-reserva.num-reserva
                                
&GLOBAL-DEFINE page0Fields      TTmab-reserva.ep-codigo ~
                                TTmab-reserva.cod-eqpto ~
                                TTmab-reserva.cod-rota-dest ~
                                TTmab-reserva.cod-rota-orig ~
                                TTmab-reserva.cod-usuar ~
                                TTmab-reserva.dat-atualiz ~
                                TTmab-reserva.dat-reserva-final ~
                                TTmab-reserva.dat-reserva-inicial ~
                                TTmab-reserva.hra-reserva-final ~
                                TTmab-reserva.hra-reserva-inicial ~
                                TTmab-reserva.ep-codigo-matr ~
                                TTmab-reserva.cod-estabel-matr ~
                                TTmab-reserva.cod-matr ~
                                TTmab-reserva.val-km-estimad ~
                                TTmab-reserva.dsl-obs


&GLOBAL-DEFINE page1Fields       

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
&Scoped-Define ENABLED-FIELDS TTmab-reserva.num-reserva ~
TTmab-reserva.dat-reserva-inicial TTmab-reserva.hra-reserva-inicial ~
TTmab-reserva.cod-usuar TTmab-reserva.dat-reserva-final ~
TTmab-reserva.hra-reserva-final TTmab-reserva.dat-atualiz ~
TTmab-reserva.cod-rota-orig TTmab-reserva.cod-rota-dest ~
TTmab-reserva.ep-codigo TTmab-reserva.cod-eqpto ~
TTmab-reserva.ep-codigo-matr TTmab-reserva.cod-estabel-matr ~
TTmab-reserva.cod-matr TTmab-reserva.val-km-estimad TTmab-reserva.dsl-obs 
&Scoped-define ENABLED-TABLES TTmab-reserva
&Scoped-define FIRST-ENABLED-TABLE TTmab-reserva
&Scoped-Define ENABLED-OBJECTS RECT-30 RECT-31 RECT-32 rtKeys rtToolBar ~
cLocalOrig cLocalDest cDescEmp cDescEqpto cNomeMot btOK btSave btCancel ~
btHelp 
&Scoped-Define DISPLAYED-FIELDS TTmab-reserva.num-reserva ~
TTmab-reserva.dat-reserva-inicial TTmab-reserva.hra-reserva-inicial ~
TTmab-reserva.cod-usuar TTmab-reserva.dat-reserva-final ~
TTmab-reserva.hra-reserva-final TTmab-reserva.dat-atualiz ~
TTmab-reserva.cod-rota-orig TTmab-reserva.cod-rota-dest ~
TTmab-reserva.ep-codigo TTmab-reserva.cod-eqpto ~
TTmab-reserva.ep-codigo-matr TTmab-reserva.cod-estabel-matr ~
TTmab-reserva.cod-matr TTmab-reserva.val-km-estimad TTmab-reserva.dsl-obs 
&Scoped-define DISPLAYED-TABLES TTmab-reserva
&Scoped-define FIRST-DISPLAYED-TABLE TTmab-reserva
&Scoped-Define DISPLAYED-OBJECTS cLocalOrig cLocalDest cDescEmp cDescEqpto ~
cNomeMot 

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
     SIZE 36 BY .88 NO-UNDO.

DEFINE VARIABLE cDescEqpto AS CHARACTER FORMAT "X(30)":U 
     VIEW-AS FILL-IN 
     SIZE 30 BY .88 NO-UNDO.

DEFINE VARIABLE cLocalDest AS CHARACTER FORMAT "X(30)":U 
     VIEW-AS FILL-IN 
     SIZE 36 BY .88 NO-UNDO.

DEFINE VARIABLE cLocalOrig AS CHARACTER FORMAT "X(30)":U 
     VIEW-AS FILL-IN 
     SIZE 36 BY .88 NO-UNDO.

DEFINE VARIABLE cNomeMot AS CHARACTER FORMAT "X(30)":U 
     VIEW-AS FILL-IN 
     SIZE 36 BY .88 NO-UNDO.

DEFINE RECTANGLE RECT-30
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 90 BY 2.46.

DEFINE RECTANGLE RECT-31
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 85 BY 4.92.

DEFINE RECTANGLE RECT-32
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 90 BY 11.71.

DEFINE RECTANGLE rtKeys
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 90 BY 1.5.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 90 BY 1.42
     BGCOLOR 7 .


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fpage0
     TTmab-reserva.num-reserva AT ROW 1.29 COL 19.14 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 8.29 BY .88
     TTmab-reserva.dat-reserva-inicial AT ROW 2.75 COL 19.14 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 10 BY .88
     TTmab-reserva.hra-reserva-inicial AT ROW 2.75 COL 42 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 10 BY .88
     TTmab-reserva.cod-usuar AT ROW 2.75 COL 74 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 12 BY .88
     TTmab-reserva.dat-reserva-final AT ROW 3.75 COL 19.14 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 10 BY .88
     TTmab-reserva.hra-reserva-final AT ROW 3.75 COL 42 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 10 BY .88
     TTmab-reserva.dat-atualiz AT ROW 3.75 COL 74 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 12 BY .88
     TTmab-reserva.cod-rota-orig AT ROW 5.29 COL 19 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 10 BY .88
     cLocalOrig AT ROW 5.29 COL 29 COLON-ALIGNED NO-LABEL
     TTmab-reserva.cod-rota-dest AT ROW 6.29 COL 19 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 10 BY .88
     cLocalDest AT ROW 6.29 COL 29 COLON-ALIGNED NO-LABEL
     TTmab-reserva.ep-codigo AT ROW 7.29 COL 19 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 10 BY .88
     cDescEmp AT ROW 7.29 COL 29 COLON-ALIGNED NO-LABEL
     TTmab-reserva.cod-eqpto AT ROW 8.29 COL 19 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 16 BY .88
     cDescEqpto AT ROW 8.29 COL 35 COLON-ALIGNED NO-LABEL
     TTmab-reserva.ep-codigo-matr AT ROW 9.25 COL 19.14 COLON-ALIGNED
          LABEL "Motorista":R9
          VIEW-AS FILL-IN 
          SIZE 5 BY .88
     TTmab-reserva.cod-estabel-matr AT ROW 9.25 COL 24.29 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 5 BY .88
     TTmab-reserva.cod-matr AT ROW 9.25 COL 29.43 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 10 BY .88
     cNomeMot AT ROW 9.25 COL 39.57 COLON-ALIGNED NO-LABEL
     TTmab-reserva.val-km-estimad AT ROW 10.29 COL 19 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 10 BY .88
     TTmab-reserva.dsl-obs AT ROW 12.04 COL 11 NO-LABEL
          VIEW-AS EDITOR MAX-CHARS 2000 SCROLLBAR-VERTICAL
          SIZE 77 BY 4.21
     btOK AT ROW 17 COL 2
     btSave AT ROW 17 COL 13
     btCancel AT ROW 17 COL 24
     btHelp AT ROW 17 COL 80
     "Usu†rio:" VIEW-AS TEXT
          SIZE 6 BY .54 AT ROW 2.92 COL 69.43
     "Data Inicial:" VIEW-AS TEXT
          SIZE 7.72 BY .54 AT ROW 2.88 COL 13
     "Atualizaá∆o:" VIEW-AS TEXT
          SIZE 8 BY .54 AT ROW 3.92 COL 67.72
     "Observaá∆o:" VIEW-AS TEXT
          SIZE 9.14 BY .54 AT ROW 11.33 COL 7.86
     "Empresa:" VIEW-AS TEXT
          SIZE 6.57 BY .54 AT ROW 7.46 COL 14.29
     "Hora Inicial:" VIEW-AS TEXT
          SIZE 7.72 BY .54 AT ROW 2.92 COL 36
     "Percurso:" VIEW-AS TEXT
          SIZE 6.57 BY .54 AT ROW 10.46 COL 14
     "Hora Final:" VIEW-AS TEXT
          SIZE 7.72 BY .54 AT ROW 3.96 COL 36
     "Data Final:" VIEW-AS TEXT
          SIZE 7.72 BY .54 AT ROW 4 COL 13
     "Documento Reserva" VIEW-AS TEXT
          SIZE 15 BY .54 AT ROW 1.42 COL 6
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 90 BY 17.29
         FONT 1.

/* DEFINE FRAME statement is approaching 4K Bytes.  Breaking it up   */
DEFINE FRAME fpage0
     RECT-30 AT ROW 2.54 COL 1
     RECT-31 AT ROW 11.58 COL 5
     RECT-32 AT ROW 5.04 COL 1
     rtKeys AT ROW 1 COL 1
     rtToolBar AT ROW 16.79 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 90 BY 17.29
         FONT 1.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: wMaintenanceNoNavigation
   Allow: Basic,Browse,DB-Fields,Window,Query
   Add Fields to: Neither
   Temp-Tables and Buffers:
      TABLE: TTmab-reserva T "?" NO-UNDO movfro mab-reserva
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
         TITLE              = "Manutená∆o de Reservas"
         HEIGHT             = 17.17
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
   FRAME-NAME                                                           */
/* SETTINGS FOR FILL-IN TTmab-reserva.ep-codigo-matr IN FRAME fpage0
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
ON END-ERROR OF wMaintenanceNoNavigation /* Manutená∆o de Reservas */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wMaintenanceNoNavigation wMaintenanceNoNavigation
ON WINDOW-CLOSE OF wMaintenanceNoNavigation /* Manutená∆o de Reservas */
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
    
     /** Salva Registro **/
    RUN saveRecord IN THIS-PROCEDURE.
    IF RETURN-VALUE = "OK":U THEN
        APPLY "CLOSE":U TO THIS-PROCEDURE.
    else do:
        if pcAction <> "UPDATE":U then do:
           /** Busca a numeraá∆o da Reserva **/
         run buscaNrReserva in {&hDBOTable} (output {&ttTable}.num-reserva).
            /** Mostra documento em tela **/
            display {&ttTable}.num-reserva
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
        /** Busca a numeraá∆o da Reserva **/
         run buscaNrReserva in {&hDBOTable} (output {&ttTable}.num-reserva).
        /** Mostra documento em tela **/
        display {&ttTable}.num-reserva
            with frame fPage0.
        return no-apply.
    end.
       
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME TTmab-reserva.cod-eqpto
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL TTmab-reserva.cod-eqpto wMaintenanceNoNavigation
ON LEAVE OF TTmab-reserva.cod-eqpto IN FRAME fpage0 /* Equipamento */
DO:
    FOR FIRST mab-eqpto FIELDS (ep-codigo cod-eqpto cod-model)
       WHERE mab-eqpto.ep-codigo = INPUT FRAME fPage0 TTmab-reserva.ep-codigo
       AND   mab-eqpto.cod-eqpto = INPUT FRAME fPage0 TTmab-reserva.cod-eqpto,
       EACH mab-model FIELDS (cod-model des-model)
            WHERE mab-model.cod-model = mab-eqpto.cod-model NO-LOCK:
            ASSIGN cDescEqpto = mab-model.des-model.
            DISP cDescEqpto WITH FRAME fPage0. 
    
   END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL TTmab-reserva.cod-eqpto wMaintenanceNoNavigation
ON MOUSE-SELECT-DBLCLICK OF TTmab-reserva.cod-eqpto IN FRAME fpage0 /* Equipamento */
OR f5 OF TTmab-reserva.cod-eqpto IN FRAME fPage0 DO:

        {method/ZoomFields.i
           &ProgramZoom="frzoom~\z01fr007.w"
           &FieldZoom1="cod-eqpto"
           &FieldScreen1=" TTmab-reserva.cod-eqpto"
           &Frame1="fPage0"
           &EnableImplant="YES"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME TTmab-reserva.cod-estabel-matr
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL TTmab-reserva.cod-estabel-matr wMaintenanceNoNavigation
ON F5 OF TTmab-reserva.cod-estabel-matr IN FRAME fpage0 /* cod-estabel-matr */
DO:
  APPLY "F5":U TO TTmab-reserva.cod-matr IN FRAME fPage0.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL TTmab-reserva.cod-estabel-matr wMaintenanceNoNavigation
ON MOUSE-SELECT-DBLCLICK OF TTmab-reserva.cod-estabel-matr IN FRAME fpage0 /* cod-estabel-matr */
DO:
  APPLY "F5":U TO TTmab-reserva.cod-matr IN FRAME fPage0.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME TTmab-reserva.cod-matr
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL TTmab-reserva.cod-matr wMaintenanceNoNavigation
ON F5 OF TTmab-reserva.cod-matr IN FRAME fpage0 /* cod-matr */
DO:
    {method/zoomfields.i 
           &ProgramZoom="frzoom~\z01fr017.w"
           &FieldZoom1="cod-matr"
           &FieldScreen1="TTmab-reserva.cod-matr"
           &Frame1="fPage0"
           &FieldZoom2="nom-motoris"
           &FieldScreen2="cNomeMot"
           &Frame2="fPage0"
           &FieldZoom3="ep-codigo"
           &FieldScreen3="TTmab-reserva.ep-codigo-matr"
           &Frame3="fPage0"           
           &FieldZoom4="cod-estabel"
           &FieldScreen4="TTmab-reserva.cod-estabel-matr"
           &Frame4="fPage0"
           &EnableImplant="YES"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL TTmab-reserva.cod-matr wMaintenanceNoNavigation
ON LEAVE OF TTmab-reserva.cod-matr IN FRAME fpage0 /* cod-matr */
DO:
      for first mab-param
          where mab-param.cdn-param = 52 no-lock:
          if mab-param.des-valor = "1":U then do:
              IF  INPUT FRAME fPage0 TTmab-reserva.ep-codigo-matr = "" OR INPUT FRAME fPage0 TTmab-reserva.cod-estabel-matr = "" THEN DO:
                  for first mab-motoris
                      where mab-motoris.cod-matr = TTmab-reserva.cod-matr:screen-value in frame fPage0 no-lock:
                      assign TTmab-reserva.ep-codigo-matr:screen-value in frame fPage0 = string(mab-motoris.ep-codigo)
                             TTmab-reserva.cod-estabel-matr:screen-value in frame fPage0 = mab-motoris.cod-estabel.
                  end.
                  if not avail mab-motoris then do:
                      assign TTmab-reserva.ep-codigo-matr:screen-value in frame fPage0 = ""
                             TTmab-reserva.cod-estabel-matr:screen-value in frame fPage0 = "".
                  end.
              END.
          end.
      end.

      {method/ReferenceFields.i
      &HandleDBOLeave="hDBOMotorista"
      &KeyValue1="input frame fPage0 TTmab-reserva.ep-codigo-matr"
      &KeyValue2="input frame fPage0 TTmab-reserva.cod-estabel-matr"
      &KeyValue3="input frame fPage0 TTmab-reserva.cod-matr"
      &FieldName1="nom-motoris"
      &FieldScreen1="cNomeMot"
      &Frame1="fPage0"}

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL TTmab-reserva.cod-matr wMaintenanceNoNavigation
ON MOUSE-SELECT-DBLCLICK OF TTmab-reserva.cod-matr IN FRAME fpage0 /* cod-matr */
DO:
  apply "F5":U to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME TTmab-reserva.cod-rota-dest
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL TTmab-reserva.cod-rota-dest wMaintenanceNoNavigation
ON F5 OF TTmab-reserva.cod-rota-dest IN FRAME fpage0 /* Trajeto Destino */
DO:
  {method/zoomfields.i 
           &ProgramZoom="frzoom~\z01fr028.w"
           &FieldZoom1="cod-rota"
           &FieldScreen1="input frame fPage0 TTmab-reserva.cod-rota-dest"
           &Frame1="fPage0"
           &FieldZoom2="des-rota"
           &FieldScreen2="cLocalDest"
           &Frame2="fPage0"
           &EnableImplant="YES"}  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL TTmab-reserva.cod-rota-dest wMaintenanceNoNavigation
ON LEAVE OF TTmab-reserva.cod-rota-dest IN FRAME fpage0 /* Trajeto Destino */
DO:
/*    {method~/referencefields.i                                                       */
/*             &HandleDBOLeave="hDBOTrajeto"                                          */
/*             &KeyValue1="TTmab-reserva.cod-rota-dest:screen-value in frame fPage0" */
/*             &FieldName1="des-trajeto"                                              */
/*             &FieldScreen1="cLocalDest"                                             */
/*             &Frame1="fPage0"}                                                      */
/*                                                                                    */

        FOR FIRST mab-trajeto FIELDS (cod-rota des-rota) 
               WHERE mab-trajeto.cod-rota = INPUT FRAME fPage0 TTmab-reserva.cod-rota-dest NO-lock:
              ASSIGN cLocalDest = mab-trajeto.des-rota.
              
                DISP cLocalDest WITH FRAME fPage0.
          END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL TTmab-reserva.cod-rota-dest wMaintenanceNoNavigation
ON MOUSE-SELECT-DBLCLICK OF TTmab-reserva.cod-rota-dest IN FRAME fpage0 /* Trajeto Destino */
DO:
   apply "F5":U to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME TTmab-reserva.cod-rota-orig
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL TTmab-reserva.cod-rota-orig wMaintenanceNoNavigation
ON F5 OF TTmab-reserva.cod-rota-orig IN FRAME fpage0 /* Trajeto Origem */
DO:
     {method/zoomfields.i 
           &ProgramZoom="frzoom~\z01fr028.w"
           &FieldZoom1="cod-rota"
           &FieldScreen1="input frame fPage0 TTmab-reserva.cod-rota-orig"
           &Frame1="fPage0"
           &FieldZoom2="des-rota"
           &FieldScreen2="cLocalOrig"
           &Frame2="fPage0"
           &EnableImplant="YES"}  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL TTmab-reserva.cod-rota-orig wMaintenanceNoNavigation
ON LEAVE OF TTmab-reserva.cod-rota-orig IN FRAME fpage0 /* Trajeto Origem */
DO:
/*    {method~/referencefields.i                                                        */
/*             &HandleDBOLeave="hDBOTrajeto"                                           */
/*             &KeyValue1="TTmab-reserva.cod-rota-dest:screen-value in frame fPage0"  */
/*             &FieldName1="des-trajeto"                                               */
/*             &FieldScreen1="cLocalOrig"                                              */
/*             &Frame1="fPage0"}                                                       */
/*                                                                                     */

        FOR FIRST mab-trajeto FIELDS (cod-rota des-rota) 
               WHERE mab-trajeto.cod-rota = INPUT FRAME fPage0 TTmab-reserva.cod-rota-orig NO-lock:
              ASSIGN cLocalOrig = mab-trajeto.des-rota.
              
                DISP cLocalOrig WITH FRAME fPage0.
          END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL TTmab-reserva.cod-rota-orig wMaintenanceNoNavigation
ON MOUSE-SELECT-DBLCLICK OF TTmab-reserva.cod-rota-orig IN FRAME fpage0 /* Trajeto Origem */
DO:
   apply "F5":U to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME TTmab-reserva.ep-codigo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL TTmab-reserva.ep-codigo wMaintenanceNoNavigation
ON LEAVE OF TTmab-reserva.ep-codigo IN FRAME fpage0 /* ep-codigo */
DO:
    FOR FIRST empresa FIELDS (ep-codigo nome) 
               WHERE empresa.ep-codigo = INPUT FRAME fPage0 TTmab-reserva.ep-codigo NO-lock:
              ASSIGN cDescEmp = empresa.nome.
              
                DISP cDescEmp WITH FRAME fPage0.
          END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL TTmab-reserva.ep-codigo wMaintenanceNoNavigation
ON MOUSE-SELECT-DBLCLICK OF TTmab-reserva.ep-codigo IN FRAME fpage0 /* ep-codigo */
OR f5 OF TTmab-reserva.ep-codigo IN FRAME fPage0 DO:

        {method/ZoomFields.i
           &ProgramZoom="frzoom~\z01fr007.w"
           &FieldZoom1="ep-codigo"
           &FieldScreen1="TTmab-reserva.ep-codigo"
           &Frame1="fPage0"
           &EnableImplant="YES"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME TTmab-reserva.ep-codigo-matr
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL TTmab-reserva.ep-codigo-matr wMaintenanceNoNavigation
ON F5 OF TTmab-reserva.ep-codigo-matr IN FRAME fpage0 /* Motorista */
DO:
  APPLY "F5":U TO TTmab-reserva.cod-matr IN FRAME fPage0.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL TTmab-reserva.ep-codigo-matr wMaintenanceNoNavigation
ON MOUSE-SELECT-DBLCLICK OF TTmab-reserva.ep-codigo-matr IN FRAME fpage0 /* Motorista */
DO:
  APPLY "F5":U TO TTmab-reserva.cod-matr IN FRAME fPage0.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME TTmab-reserva.hra-reserva-final
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL TTmab-reserva.hra-reserva-final wMaintenanceNoNavigation
ON LEAVE OF TTmab-reserva.hra-reserva-final IN FRAME fpage0 /* hra-reserva-final */
DO:
    assign cHora2 = TTmab-reserva.hra-reserva-final:screen-value in frame fPage0.
     run piFormataHorarioSeg (input-output cHora2).
     if return-value = "NOK":U then do:
         apply "ENTRY":U to TTmab-reserva.hra-reserva-final in frame fPage0.
         return no-apply.
     end.
     assign TTmab-reserva.hra-reserva-final:screen-value in frame fPage0 = cHora2.    

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME TTmab-reserva.hra-reserva-inicial
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL TTmab-reserva.hra-reserva-inicial wMaintenanceNoNavigation
ON LEAVE OF TTmab-reserva.hra-reserva-inicial IN FRAME fpage0 /* hra-reserva-inicial */
DO:
    assign cHora = TTmab-reserva.hra-reserva-inicial:screen-value in frame fPage0.
     run piFormataHorarioSeg (input-output cHora).
     if return-value = "NOK":U then do:
         apply "ENTRY":U to TTmab-reserva.hra-reserva-inicial in frame fPage0.
         return no-apply.
     end.
     assign TTmab-reserva.hra-reserva-inicial:screen-value in frame fPage0 = cHora.    

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wMaintenanceNoNavigation 


TTmab-reserva.ep-codigo:load-mouse-pointer ("image/lupa.cur") in frame fPage0.
TTmab-reserva.cod-eqpto:load-mouse-pointer ("image/lupa.cur") in frame fPage0.
TTmab-reserva.ep-codigo-matr:load-mouse-pointer ("image/lupa.cur") in frame fPage0.
TTmab-reserva.cod-estabel-matr:load-mouse-pointer ("image/lupa.cur") in frame fPage0.
TTmab-reserva.cod-matr:load-mouse-pointer ("image/lupa.cur") in frame fPage0.
TTmab-reserva.cod-rota-orig:load-mouse-pointer ("image/lupa.cur") in frame fPage0.
TTmab-reserva.cod-rota-dest:load-mouse-pointer ("image/lupa.cur") in frame fPage0.
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
DEFINE VARIABLE cTrajeto AS CHARACTER  NO-UNDO.

{utp/ut-liter.i "Trajeto" MAB}
ASSIGN cTrajeto = RETURN-VALUE.
{utp/ut-liter.i "Origem"}
ASSIGN {&ttTable}.cod-rota-orig:LABEL IN FRAME fPage0 = cTrajeto + " " + RETURN-VALUE.
{utp/ut-liter.i "Destino"}
ASSIGN {&ttTable}.cod-rota-dest:LABEL IN FRAME fPage0 = cTrajeto + " " + RETURN-VALUE.
    
IF pcAction = "ADD":U OR pcAction = "Update":U OR pcAction = "COPY":U THEN DO:
    apply "LEAVE":U to {&ttTable}.ep-codigo    in frame fPage0.
    apply "LEAVE":U to {&ttTable}.cod-eqpto      in frame fPage0.
    apply "LEAVE":U to {&ttTable}.cod-rota-dest in frame fPage0.
    apply "LEAVE":U to {&ttTable}.cod-rota-orig in frame fPage0.
    apply "LEAVE":U to {&ttTable}.cod-matr      in frame fPage0.
 END.



 if pcAction <> "UPDATE":U then do:
     /** Busca a numeraá∆o da Reserva **/
     run buscaNrReserva in {&hDBOTable} (output {&ttTable}.num-reserva).
     /** Data Atual **/
     assign {&ttTable}.dat-atualiz = today
            {&ttTable}.cod-usuar = c-seg-usuario.
     display {&ttTable}.dat-atualiz
             {&ttTable}.cod-usuar
         with frame fPage0.
 end.
 assign {&ttTable}.cod-usuar:sensitive in frame fPage0 = no.
 /** Mostra documento em tela **/
 display {&ttTable}.num-reserva
     with frame fPage0.




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
IF AVAIL {&ttTable} THEN
/** Desabilita campos em tela que n∆o s∆o atualizados pelo usu†rio **/
disable {&ttTable}.cod-usuar
        {&ttTable}.num-reserva
        {&ttTable}.dat-atualiz
    with frame fPage0.

for first mab-param
    where mab-param.cdn-param = 52 no-lock:
    if mab-param.des-valor = "1":U then do:
        assign TTmab-reserva.ep-codigo-matr:sensitive in frame fPage0 = no
               TTmab-reserva.cod-estabel-matr:sensitive in frame fPage0 = no.
    end.
    else do:
        assign TTmab-reserva.ep-codigo-matr:sensitive in frame fPage0 = yes
               TTmab-reserva.cod-estabel-matr:sensitive in frame fPage0 = yes.
    end.
end.


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

/** Atualiza o campo hora invertida. Ser† gravado no 
    formato "AAAAMMDDHHMMSS" (Ano+Màs+Dia+Hora+Minuto+Segundo) **/
run converteParaHoraInvertidaInicial in {&hDBOTable} (input TTmab-reserva.dat-reserva-inicial:screen-value in frame fPage0,
                                                      input  TTmab-reserva.hra-reserva-inicial:screen-value in frame fPage0,
                                                      output HoraInvIni ).

ASSIGN  TTmab-reserva.val-dat-hora-invrtda-inic  = HoraInvIni. 

run converteParaHoraInvertidaFinal in {&hDBOTable} (input TTmab-reserva.dat-reserva-final:screen-value in frame fPage0,
                                                      input  TTmab-reserva.hra-reserva-final:screen-value in frame fPage0,
                                                      output HoraInvFim).

ASSIGN   TTmab-reserva.val-dat-hora-invrtda-final   = HoraInvFim.






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
IF NOT VALID-HANDLE({&hDBOTable}) OR 
         {&hDBOTable}:TYPE <> "PROCEDURE":U OR
         {&hDBOTable}:FILE-NAME <> "frbo~\bofr062.p":U THEN DO:
        RUN frbo~/bofr062.p PERSISTENT SET  {&hDBOTable}.
END.
RUN openQueryStatic in   {&hDBOTable} (input "Main":U) NO-ERROR.



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

     
RETURN "OK":U.    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

