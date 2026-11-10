&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          movfro           PROGRESS
*/
&Scoped-define WINDOW-NAME wMaintenanceNoNavigation


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE ttAmostraOleo NO-UNDO LIKE mao-amostra-oleo
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
{include/i-prgvrs.i AO0301A 2.00.00.001}  /*** 010001 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i ao0301a MAO}
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
&GLOBAL-DEFINE Program           AO0301A
&GLOBAL-DEFINE Version           2.00.00.001

&GLOBAL-DEFINE Folder            YES
&GLOBAL-DEFINE InitialPage       1


&GLOBAL-DEFINE FolderLabels      P†gina 1,Observaá∆o

&GLOBAL-DEFINE ttTable           ttAmostraOleo
&GLOBAL-DEFINE hDBOTable         hDBOAmostraOleo
&GLOBAL-DEFINE DBOTable          mao-amostra-oleo

&GLOBAL-DEFINE page0KeyFields   ttAmostraOleo.cod-amostra-fisic 
                                
&GLOBAL-DEFINE page0Fields      ttAmostraOleo.hra-amostra ttAmostraOleo.dat-amostra ~
                                
 
 
&GLOBAL-DEFINE page1Fields     ttAmostraOleo.val-quant ttAmostraOleo.it-codigo ~
                               ttAmostraOleo.idi-estado-amostra ttAmostraOleo.ep-codigo ~
                               ttAmostraOleo.cod-usuar ttAmostraOleo.cod-tip-mater ~
                               ttAmostraOleo.cod-eqpto ttAmostraOleo.cod-comptmento ~
                               ttAmostraOleo.num-docto ttAmostraOleo.cod-evento






 
&GLOBAL-DEFINE page2Fields  ttAmostraOleo.dsl-obs   
                               

/* Parameters Definitions ---                                           */
DEFINE INPUT PARAMETER prTable         AS ROWID     NO-UNDO.
DEFINE INPUT PARAMETER pcAction        AS CHARACTER NO-UNDO.
DEFINE INPUT PARAMETER phCaller        AS HANDLE    NO-UNDO.

/* Local Variable Definitions ---                                       */
DEFINE VARIABLE iSituacao    AS INTEGER   NO-UNDO.
DEFINE VARIABLE iEmpOrig     AS INTEGER   NO-UNDO.
DEFINE VARIABLE cEqptoOrig   AS CHARACTER NO-UNDO.
DEFINE VARIABLE iEmpDest     AS INTEGER   NO-UNDO.
DEFINE VARIABLE cEqptoDest   AS CHARACTER NO-UNDO.
DEFINE VARIABLE l-habilita   AS LOGICAL   INITIAL NO NO-UNDO.
DEFINE VARIABLE HoraInv      AS DEC  NO-UNDO.
DEFINE VARIABLE cHora        AS CHARACTER format "00:00:00" NO-UNDO.

DEF VAR var-ep-codigo LIKE ttAmostraOleo.ep-codigo NO-UNDO.
DEF VAR var-cod-comptmento LIKE ttAmostraOleo.cod-comptmento NO-UNDO.
DEF VAR var-cod-evento LIKE ttAmostraOleo.cod-evento NO-UNDO.
DEF VAR var-cod-tip-mater LIKE ttAmostraOleo.cod-tip-mater NO-UNDO.
DEF VAR var-it-codigo LIKE ttAmostraOleo.it-codigo NO-UNDO.
DEF VAR var-cod-eqpto LIKE ttAmostraOleo.cod-eqpto NO-UNDO.

DEFINE VARIABLE i-origem LIKE ttAmostraOleo.num-amostra-oleo  NO-UNDO.
DEFINE VARIABLE i-destino LIKE ttAmostraOleo.num-amostra-oleo NO-UNDO.

/* Local Variable Definitions (DBOs Handles) --- */
DEFINE VARIABLE {&hDBOTable}  AS HANDLE NO-UNDO.
DEFINE VARIABLE hDBOModelo    AS HANDLE NO-UNDO.
DEFINE VARIABLE hDBOEqpto     AS HANDLE NO-UNDO.
DEFINE VARIABLE hDBOTpMatl    AS HANDLE NO-UNDO.
DEFINE VARIABLE hDBOCompto    AS HANDLE NO-UNDO.
DEFINE VARIABLE hDBOEvento    AS HANDLE NO-UNDO.
DEFINE VARIABLE hDBOLubrific  AS HANDLE NO-UNDO.

/*variaveis globais usadas no z01fr004*/
define new global shared variable iEmpresa      like mab-comptmento-eqpto.ep-codigo   no-undo.
define new global shared variable cEqpto        like mab-comptmento-eqpto.cod-eqpto   no-undo.

/** Zoom Smart **/
DEFINE VARIABLE wh-pesquisa AS HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE adm-broker-hdl AS HANDLE NO-UNDO.

DEFINE VARIABLE c-return AS CHARACTER INITIAL "NOK":U NO-UNDO.

{abp/ab9000.i}  /** Procedure piFormataSegundoParaHora**/

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE MaintenanceNoNavigation
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fpage0

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS ttAmostraOleo.num-amostra-oleo ~
ttAmostraOleo.dat-amostra ttAmostraOleo.hra-amostra ~
ttAmostraOleo.cod-amostra-fisic 
&Scoped-define ENABLED-TABLES ttAmostraOleo
&Scoped-define FIRST-ENABLED-TABLE ttAmostraOleo
&Scoped-Define ENABLED-OBJECTS btOK btSave btCancel btHelp rtKeys rtToolBar 
&Scoped-Define DISPLAYED-FIELDS ttAmostraOleo.num-amostra-oleo ~
ttAmostraOleo.dat-amostra ttAmostraOleo.hra-amostra ~
ttAmostraOleo.cod-amostra-fisic 
&Scoped-define DISPLAYED-TABLES ttAmostraOleo
&Scoped-define FIRST-DISPLAYED-TABLE ttAmostraOleo


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

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 90 BY 1.42
     BGCOLOR 7 .

DEFINE VARIABLE fiDescCompto AS CHARACTER FORMAT "X(30)":U 
     VIEW-AS FILL-IN 
     SIZE 30 BY .88 NO-UNDO.

DEFINE VARIABLE fiDescEqpto AS CHARACTER FORMAT "X(60)":U 
     VIEW-AS FILL-IN 
     SIZE 30 BY .88 NO-UNDO.

DEFINE VARIABLE fiDescEvento AS CHARACTER FORMAT "X(30)":U 
     VIEW-AS FILL-IN 
     SIZE 30 BY .88 NO-UNDO.

DEFINE VARIABLE fiDescMatl AS CHARACTER FORMAT "X(30)":U 
     VIEW-AS FILL-IN 
     SIZE 30 BY .88 NO-UNDO.

DEFINE VARIABLE fiText-3 AS CHARACTER FORMAT "X(256)":U INITIAL "Estado" 
      VIEW-AS TEXT 
     SIZE 6 BY .63
     FONT 1 NO-UNDO.

DEFINE RECTANGLE RECT-15
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 59 BY 1.75.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fpage0
     ttAmostraOleo.num-amostra-oleo AT ROW 1.33 COL 22 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 10 BY .88
     ttAmostraOleo.dat-amostra AT ROW 2.33 COL 22 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 10 BY .88
     ttAmostraOleo.hra-amostra AT ROW 2.33 COL 32.14 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 8 BY .88
     ttAmostraOleo.cod-amostra-fisic AT ROW 2.33 COL 60 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 12 BY .88
     btOK AT ROW 17.25 COL 2
     btSave AT ROW 17.25 COL 13
     btCancel AT ROW 17.25 COL 24
     btHelp AT ROW 17.25 COL 80
     rtKeys AT ROW 1 COL 1
     rtToolBar AT ROW 17 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 90 BY 17.42
         FONT 1.

DEFINE FRAME fPage1
     ttAmostraOleo.idi-estado-amostra AT ROW 2.13 COL 14.57 NO-LABEL
          VIEW-AS RADIO-SET HORIZONTAL
          RADIO-BUTTONS 
                    "Pendente", 1,
"Aprovado", 2,
"Aprovado pelo Usu†rio", 3,
"Reprovado", 4
          SIZE 50.43 BY .71
     ttAmostraOleo.ep-codigo AT ROW 3.75 COL 11.29 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 5 BY .88
     ttAmostraOleo.cod-eqpto AT ROW 3.75 COL 16.72 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 16 BY .88
     fiDescEqpto AT ROW 3.75 COL 33 COLON-ALIGNED NO-LABEL
     ttAmostraOleo.cod-comptmento AT ROW 4.75 COL 11.29 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 8 BY .88
     fiDescCompto AT ROW 4.75 COL 19.43 COLON-ALIGNED NO-LABEL
     ttAmostraOleo.cod-evento AT ROW 5.75 COL 11.29 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 8 BY .88
     ttAmostraOleo.num-docto AT ROW 5.75 COL 72.86 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 10 BY .88
     fiDescEvento AT ROW 5.75 COL 19.43 COLON-ALIGNED NO-LABEL
     ttAmostraOleo.cod-tip-mater AT ROW 6.75 COL 11.29 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 8 BY .88
     fiDescMatl AT ROW 6.75 COL 19.43 COLON-ALIGNED NO-LABEL
     ttAmostraOleo.it-codigo AT ROW 6.75 COL 66.86 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 16 BY .88
     ttAmostraOleo.val-quant AT ROW 7.75 COL 11.29 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 10 BY .88
     ttAmostraOleo.cod-usuar AT ROW 7.75 COL 70.86 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 12 BY .88
     fiText-3 AT ROW 1.25 COL 8 COLON-ALIGNED NO-LABEL
     RECT-15 AT ROW 1.5 COL 9
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.57 ROW 5
         SIZE 84.43 BY 10.71
         FONT 1.

DEFINE FRAME fPage2
     ttAmostraOleo.dsl-obs AT ROW 1.5 COL 2.57 NO-LABEL
          VIEW-AS EDITOR MAX-CHARS 2000 SCROLLBAR-VERTICAL
          SIZE 82 BY 9.75
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.57 ROW 5
         SIZE 84.43 BY 10.71
         FONT 1.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: MaintenanceNoNavigation
   Allow: Basic,Browse,DB-Fields,Window,Query
   Add Fields to: Neither
   Temp-Tables and Buffers:
      TABLE: ttAmostraOleo T "?" NO-UNDO movfro mao-amostra-oleo
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
         HEIGHT             = 17.42
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
/* REPARENT FRAME */
ASSIGN FRAME fPage1:FRAME = FRAME fpage0:HANDLE
       FRAME fPage2:FRAME = FRAME fpage0:HANDLE.

/* SETTINGS FOR FRAME fpage0
   FRAME-NAME Custom                                                    */
/* SETTINGS FOR FRAME fPage1
   Custom                                                               */
/* SETTINGS FOR FRAME fPage2
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

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME fPage2
/* Query rebuild information for FRAME fPage2
     _Query            is NOT OPENED
*/  /* FRAME fPage2 */
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

    /** Salva Registro **/
    RUN saveRecord IN THIS-PROCEDURE.
    IF RETURN-VALUE = "OK":U THEN DO:
       if pcAction = "COPY":U then do:
           /*Copia os filhos para a nova amostra de oleo */
           ASSIGN i-destino = INT(ttAmostraOleo.num-amostra-oleo:SCREEN-VALUE IN FRAME fPage0).
           run copiaFilhos in {&hDBOTable} (input  i-destino, 
                                            input  i-origem,
                                            INPUT-OUTPUT TABLE RowErrors).
           /** Mostra Erros **/
           if return-value = "NOK":U THEN 
               RUN piMostraErros IN THIS-PROCEDURE.
       END.
       APPLY "CLOSE":U TO THIS-PROCEDURE.

    END.
    else do:
        if pcAction <> "UPDATE":U then do:
            /** Busca a numeraá∆o da Amostra, pois pode ter sido 
                inclu°do um outro registro durante este erro **/
            run buscaDocumento in {&hDBOTable} (output {&ttTable}.num-amostra-oleo).
            /** Mostra documento em tela **/
            display {&ttTable}.num-amostra-oleo
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
        /** Busca a numeraá∆o do Apontamento, pois pode ter sido 
            inclu°do um outro registro durante este erro **/
        run buscaDocumento in {&hDBOTable} (output {&ttTable}.num-amostra-oleo).
        /** Mostra documento em tela **/
        display {&ttTable}.num-amostra-oleo
            with frame fPage0.
        assign {&tttable}.idi-estado-amostra:sensitive in frame fPage1 = no
               {&ttTable}.cod-usuar:sensitive in frame fPage1          = no.
        return no-apply.
    end.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage1
&Scoped-define SELF-NAME ttAmostraOleo.cod-comptmento
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ttAmostraOleo.cod-comptmento wMaintenanceNoNavigation
ON LEAVE OF ttAmostraOleo.cod-comptmento IN FRAME fPage1 /* Compartimento */
DO:
 {method/referenceFields.i
        &HandleDBOLeave="hDBOCompto"
        &KeyValue1="{&ttTable}.cod-comptmento:screen-value in frame fPage1"
        &FieldName1="des-comptmento"
        &FieldScreen1="fiDescCompto"
        &Frame1="fPage1"}
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ttAmostraOleo.cod-comptmento wMaintenanceNoNavigation
ON MOUSE-SELECT-DBLCLICK OF ttAmostraOleo.cod-comptmento IN FRAME fPage1 /* Compartimento */
OR "F5":U OF {&ttTable}.cod-comptmento IN FRAME fPage1 DO:
/*         {method/zoomfields.i                         */
/*            &ProgramZoom="frzoom/z01fr003.w"          */
/*            &FieldZoom1="cod-comptmento"              */
/*            &FieldScreen1="{&ttTable}.cod-comptmento" */
/*            &Frame1="fPage1"                          */
/*            &FieldZoom2="des-comptmento"              */
/*            &FieldScreen2="fiDescCompto"              */
/*            &Frame2="fPage1"                          */
/*            &EnableImplant="YES"}                     */

        assign iEmpresa = &IF "{&mguni_version}" >= "2.071" &THEN {&ttTable}.ep-codigo:SCREEN-VALUE IN FRAME fPage1 &else INT({&ttTable}.ep-codigo:SCREEN-VALUE IN FRAME fPage1) &ENDIF 
               cEqpto   = {&ttTable}.cod-eqpto:SCREEN-VALUE IN FRAME fPage1.

        {method/zoomfields.i 
           &ProgramZoom="frzoom/z01fr004.w"
           &FieldZoom1="cod-comptmento"
           &FieldScreen1="{&ttTable}.cod-comptmento"
           &Frame1="fPage1"
           &FieldZoom2="des-comptmento"
           &FieldScreen2="fiDescCompto"
           &Frame2="fPage1"
           &EnableImplant="YES"}    

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME ttAmostraOleo.cod-eqpto
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ttAmostraOleo.cod-eqpto wMaintenanceNoNavigation
ON ENTRY OF ttAmostraOleo.cod-eqpto IN FRAME fPage1 /* cod-eqpto */
DO:
    APPLY "leave":U TO {&ttTable}.cod-eqpto IN FRAME fPage1.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ttAmostraOleo.cod-eqpto wMaintenanceNoNavigation
ON LEAVE OF ttAmostraOleo.cod-eqpto IN FRAME fPage1 /* cod-eqpto */
DO:

  DEFINE VARIABLE cModel AS CHARACTER  NO-UNDO.
      if input frame fPage1 {&ttTable}.ep-codigo <> &IF "{&mguni_version}" >= "2.071" &THEN "" &else 0 &ENDIF
        and {&ttTable}.cod-eqpto:screen-value in frame fPage1 <> "":U  then do:
          RUN goToKey      IN hDBOEqpto (input frame fPage1 {&ttTable}.ep-codigo,
                                         input frame fPage1 {&ttTable}.cod-eqpto).
          RUN getCharField IN hDBOEqpto (input "cod-model":U, output cModel).
         {method/referenceFields.i
                &HandleDBOLeave="hDBOModelo"
                &KeyValue1="cModel"
                &FieldName1="des-model"
                &FieldScreen1="fiDescEqpto"
                &Frame1="fPage1"}
      end.
      else 
         assign fiDescEqpto:screen-value in frame fPage1 = "":U.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ttAmostraOleo.cod-eqpto wMaintenanceNoNavigation
ON MOUSE-SELECT-DBLCLICK OF ttAmostraOleo.cod-eqpto IN FRAME fPage1 /* cod-eqpto */
OR F5 OF {&ttTable}.cod-eqpto IN FRAME fPage1 DO:
    {method/zoomfields.i &ProgramZoom="frzoom/z01fr007.w"
                         &FieldZoom1="cod-eqpto"
                         &FieldScreen1="{&ttTable}.cod-eqpto"
                         &Frame1="fPage1"
                         &FieldZoom2="ep-codigo"             
                         &FieldScreen2="{&ttTable}.ep-codigo"
                         &Frame2="fPage1"                    
                         &EnableImplant="no"}
                         
        APPLY "entry":U TO {&ttTable}.cod-eqpto IN FRAME fPage1.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME ttAmostraOleo.cod-evento
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ttAmostraOleo.cod-evento wMaintenanceNoNavigation
ON LEAVE OF ttAmostraOleo.cod-evento IN FRAME fPage1 /* Evento */
DO:
 {method/referenceFields.i
        &HandleDBOLeave="hDBOEvento"
        &KeyValue1="{&ttTable}.cod-evento:screen-value in frame fPage1"
        &FieldName1="des-evento"
        &FieldScreen1="fiDescEvento"
        &Frame1="fPage1"}  
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ttAmostraOleo.cod-evento wMaintenanceNoNavigation
ON MOUSE-SELECT-DBLCLICK OF ttAmostraOleo.cod-evento IN FRAME fPage1 /* Evento */
OR "F5":U OF {&ttTable}.cod-evento IN FRAME fPage1 DO:
        {method/zoomfields.i 
           &ProgramZoom="frzoom/z01fr010.w"
           &FieldZoom1="cod-evento"
           &FieldScreen1="{&ttTable}.cod-evento"
           &Frame1="fPage1"
           &FieldZoom2="des-evento"
           &FieldScreen2="fiDescEvento"
           &Frame2="fPage1"
           &RunMethod="run setaFiltro in hProgramZoom (input yes,input yes,input yes,input yes,input yes,input yes)."
           &EnableImplant="YES"}    
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME ttAmostraOleo.cod-tip-mater
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ttAmostraOleo.cod-tip-mater wMaintenanceNoNavigation
ON F5 OF ttAmostraOleo.cod-tip-mater IN FRAME fPage1 /* Tipo Material */
DO:
   {method/zoomfields.i 
           &ProgramZoom="frzoom/z01fr026.w"
           &FieldZoom1="cod-tip-mater"
           &FieldScreen1="{&ttTable}.cod-tip-mater"
           &Frame1="fPage1"
           &FieldZoom2="des-tip-mater"
           &FieldScreen2="fiDescMatl"
           &Frame2="fPage1"
           &EnableImplant="YES"}    
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ttAmostraOleo.cod-tip-mater wMaintenanceNoNavigation
ON LEAVE OF ttAmostraOleo.cod-tip-mater IN FRAME fPage1 /* Tipo Material */
DO:
   {method/referenceFields.i
            &HandleDBOLeave="hDBOTpMatl"
            &KeyValue1="{&ttTable}.cod-tip-mater:screen-value in frame fPage1"
            &FieldName1="des-tip-mater"
            &FieldScreen1="fiDescMatl"
            &Frame1="fPage1"}    
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ttAmostraOleo.cod-tip-mater wMaintenanceNoNavigation
ON MOUSE-SELECT-DBLCLICK OF ttAmostraOleo.cod-tip-mater IN FRAME fPage1 /* Tipo Material */
DO:
  apply "F5":U to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME ttAmostraOleo.ep-codigo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ttAmostraOleo.ep-codigo wMaintenanceNoNavigation
ON ENTRY OF ttAmostraOleo.ep-codigo IN FRAME fPage1 /* Empresa */
DO:
  APPLY "leave":U TO {&ttTable}.cod-eqpto IN FRAME fPage1.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ttAmostraOleo.ep-codigo wMaintenanceNoNavigation
ON MOUSE-SELECT-DBLCLICK OF ttAmostraOleo.ep-codigo IN FRAME fPage1 /* Empresa */
OR F5 OF {&ttTable}.ep-codigo IN FRAME fPage1 DO:
   if avail {&ttTable} then do:
       apply "F5" to {&ttTable}.cod-eqpto in frame fPage1.
   end.
   APPLY "entry":U TO {&ttTable}.ep-codigo IN FRAME fPage1.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fpage0
&Scoped-define SELF-NAME ttAmostraOleo.hra-amostra
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ttAmostraOleo.hra-amostra wMaintenanceNoNavigation
ON LEAVE OF ttAmostraOleo.hra-amostra IN FRAME fpage0 /* hra-amostra */
DO:
  assign cHora = {&ttTable}.hra-amostra:screen-value in frame fPage0.
     run piFormataHorarioSeg (input-output cHora).
     if return-value = "NOK":U then do:
         apply "ENTRY":U to {&ttTable}.hra-amostra in frame fPage0.
         return no-apply.
     end.
     assign {&ttTable}.hra-amostra:screen-value in frame fPage0 = cHora.   
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage1
&Scoped-define SELF-NAME ttAmostraOleo.it-codigo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ttAmostraOleo.it-codigo wMaintenanceNoNavigation
ON MOUSE-SELECT-DBLCLICK OF ttAmostraOleo.it-codigo IN FRAME fPage1 /* Item */
OR F5 OF {&tttable}.it-codigo IN FRAME fPage1 DO:
   {method/zoomfields.i 
           &ProgramZoom="frzoom/z01fr027.w"
           &FieldZoom1="it-codigo"
           &FieldScreen1="{&tttable}.it-codigo"
           &Frame1="fPage1"}   
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME ttAmostraOleo.num-docto
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ttAmostraOleo.num-docto wMaintenanceNoNavigation
ON F5 OF ttAmostraOleo.num-docto IN FRAME fPage1 /* Lubrificaá∆o */
DO:
  APPLY "mouse-select-dblclick":U TO ttAmostraOleo.num-docto IN FRAME fPage1.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ttAmostraOleo.num-docto wMaintenanceNoNavigation
ON LEAVE OF ttAmostraOleo.num-docto IN FRAME fPage1 /* Lubrificaá∆o */
DO:
  ASSIGN var-ep-codigo      = INPUT FRAME fPage1 {&ttTable}.ep-codigo
         var-cod-eqpto      = INPUT FRAME fPage1 {&ttTable}.cod-eqpto
         var-cod-comptmento = INPUT FRAME fPage1 {&ttTable}.cod-comptmento
         var-cod-evento     = INPUT FRAME fPage1 {&ttTable}.cod-evento
         var-cod-tip-mater  = INPUT FRAME fPage1 {&ttTable}.cod-tip-mater
         var-it-codigo      = INPUT FRAME fPage1 {&tttable}.it-codigo.

   if input frame fPage1 {&ttTable}.num-docto <> 0 then do:
      {method/referenceFields.i
        &HandleDBOLeave="hDBOLubrific"
        &KeyValue1="{&ttTable}.num-docto:screen-value in frame fPage1"
        &KeyValue2="{&ttTable}.cod-comptmento:screen-value in frame fPage1"
        &KeyValue3="{&ttTable}.cod-evento:screen-value in frame fPage1"
        &FieldName1="ep-codigo"
        &FieldScreen1="{&ttTable}.ep-codigo"
        &Frame1="fPage1"
        &FieldName2="cod-eqpto"
        &FieldScreen2="{&ttTable}.cod-eqpto"
        &Frame2="fPage1"
        &FieldName3="cod-comptmento"
        &FieldScreen3="{&ttTable}.cod-comptmento"
        &Frame3="fPage1"
        &FieldName4="cod-evento"
        &FieldScreen4="{&ttTable}.cod-evento"
        &Frame4="fPage1"
        &FieldName5="cod-tip-mater"
        &FieldScreen5="{&ttTable}.cod-tip-mater"
        &Frame5="fPage1"
        &FieldName6="it-codigo"
        &FieldScreen6="{&tttable}.it-codigo"
        &Frame6="fPage1"}
   end.

   ASSIGN c-return = RETURN-VALUE.
   run piLeaveCampos in this-procedure.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ttAmostraOleo.num-docto wMaintenanceNoNavigation
ON MOUSE-SELECT-DBLCLICK OF ttAmostraOleo.num-docto IN FRAME fPage1 /* Lubrificaá∆o */
OR F5 OF {&ttTable}.num-docto IN FRAME fPage1 DO:

    {method/zoomfields.i &ProgramZoom="frzoom/z01fr058.w"
                         &FieldZoom1="num-docto"
                         &FieldScreen1="{&ttTable}.num-docto"
                         &Frame1="fPage1"
                         &FieldZoom2="cod-eqpto"
                         &FieldScreen2="{&ttTable}.cod-eqpto"
                         &Frame2="fPage1"
                         &FieldZoom3="ep-codigo"             
                         &FieldScreen3="{&ttTable}.ep-codigo"
                         &Frame3="fPage1"   
                         &FieldZoom4="cod-comptmento"
                         &FieldScreen4="{&ttTable}.cod-comptmento"
                         &Frame4="fPage1"
                         &FieldZoom5="cod-evento"
                         &FieldScreen5="{&ttTable}.cod-evento"
                         &Frame5="fPage1"
                         &FieldZoom6="cod-tip-mater"
                         &FieldScreen6="{&ttTable}.cod-tip-mater"
                         &Frame6="fPage1"
                         &FieldZoom7="it-codigo"
                         &FieldScreen7="{&tttable}.it-codigo"
                         &Frame7="fPage1"
                         &EnableImplant="no"}
                         
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fpage0
&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wMaintenanceNoNavigation 


/*:T--- L¢gica para inicializaá∆o do programam ---*/
{maintenancenonavigation/mainblock.i}

{&ttTable}.cod-comptmento:LOAD-MOUSE-POINTER("image/lupa.cur":U) in frame fPage1.
{&ttTable}.cod-eqpto:LOAD-MOUSE-POINTER("image/lupa.cur":U)      in frame fPage1.
{&ttTable}.cod-evento:LOAD-MOUSE-POINTER("image/lupa.cur":U)     in frame fPage1.
{&ttTable}.cod-tip-mater:LOAD-MOUSE-POINTER("image/lupa.cur":U)  in frame fPage1.
{&ttTable}.ep-codigo:LOAD-MOUSE-POINTER("image/lupa.cur":U)      in frame fPage1.
{&ttTable}.num-docto:LOAD-MOUSE-POINTER("image/lupa.cur":U)      in frame fPage1.
{&tttable}.it-codigo:load-mouse-pointer("image/lupa.cur":u)      in frame fPage1.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterDestroyInterface wMaintenanceNoNavigation 
PROCEDURE afterDestroyInterface :
/*------------------------------------------------------------------------------
  Purpose:     afterDestroyInterface
  Parameters:  <none>
  Notes:       Override (ap¢s) a finalizaá∆o do programa
------------------------------------------------------------------------------*/
/** Modelo **/
if valid-handle(hDBOModelo) then
    run destroy in hDBOModelo.


/** Equipamento **/
if valid-handle(hDBOEqpto) then
    run destroy in hDBOEqpto.

/** Material **/
if valid-handle(hDBOTpMatl) then
    run destroy in hDBOTpMatl.

/** Compartimento **/
if valid-handle(hDBOCompto) then
    run destroy in hDBOCompto.

/** Evento **/
if valid-handle(hDBOEvento) then
    run destroy in hDBOEvento.


/** Lubrificaá∆o **/
if valid-handle(hDBOLubrific) then
    run destroy in hDBOLubrific.






return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterDisplayFields wMaintenanceNoNavigation 
PROCEDURE afterDisplayFields :
/*------------------------------------------------------------------------------
  Purpose:     afterDisplayFields
  Parameters:  <none>
  Notes:       Override (ap¢s) do display dos campos em tela 
------------------------------------------------------------------------------*/
 if avail {&ttTable} then do:
    /** Descriá‰es de campos **/
    apply "LEAVE":U to {&ttTable}.cod-comptmento in frame fPage1.
    apply "LEAVE":U to {&ttTable}.cod-eqpto      in frame fPage1.
    apply "LEAVE":U to {&ttTable}.cod-tip-mater  in frame fPage1.
    apply "LEAVE":U to {&ttTable}.cod-evento     in frame fPage1.
    APPLY "leave":U TO {&ttTable}.num-docto      IN FRAME fPage1.
 end.
else do:
  assign fiDescEqpto:screen-value in frame fPage1  = "":U
         fiDescCompto:screen-value in frame fPage1 = "":U
         fiDescEvento:screen-value in frame fPage1 = "":U
         fiDescMatl:screen-value in frame fPage1   = "":U.

end.

IF pcAction = "copy":U THEN DO:
    ASSIGN {&tttable}.idi-estado-amostra:screen-value IN FRAME fPage1 = "1"
           btSave:SENSITIVE IN FRAME fPage0 = NO.
    IF i-origem = 0 THEN
       ASSIGN i-origem = INT(ttAmostraOleo.num-amostra-oleo /*:SCREEN-VALUE IN FRAME fPage0*/ ).
END.

if pcAction <> "UPDATE":U then do:
    /** Busca a numeraá∆o do Apontamento **/
    run buscaDocumento in {&hDBOTable} (output {&ttTable}.num-amostra-oleo).
    /** Data Atual **/
    assign {&ttTable}.dat-amostra = today
           {&ttTable}.cod-usuar = c-seg-usuario.
    display {&ttTable}.dat-amostra
        with frame fPage0.
     display {&ttTable}.cod-usuar
        with frame fPage1.
    /** Hora Atual **/
   run piMostraHorario in this-procedure.
end.

/** Mostra documento em tela **/
display {&ttTable}.num-amostra-oleo
    with frame fPage0.

/** Seta foco no campo correto **/
run piFocoInicial in this-procedure.

return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterInitializeInterface wMaintenanceNoNavigation 
PROCEDURE afterInitializeInterface :
/*------------------------------------------------------------------------------
  Purpose:     afterInitializeInterface
  Parameters:  <none>
  Notes:       Override (Ap¢s) inicializaá∆o da tela
------------------------------------------------------------------------------*/
assign {&tttable}.idi-estado-amostra:sensitive in frame fPage1 = no
       {&ttTable}.cod-usuar:sensitive in frame fPage1          = no.
{utp/ut-liter.i Estado }
assign fiText-3 = trim(return-value).
disp fiText-3 with frame fPage1.

/** Seta foco no campo correto **/
run afterDisplayFields in this-procedure.


RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterSaveFields wMaintenanceNoNavigation 
PROCEDURE afterSaveFields :
/*------------------------------------------------------------------------------
  Purpose:     afterSaveFields
  Parameters:  <none>
  Notes:       Override (ap¢s) a finalizaá∆o do programa
------------------------------------------------------------------------------*/
/*
    if pcAction = "COPY":U and
       avail {&ttTable} then assign {&ttTable}.r-rowid = ?.*/

    return "OK":U.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE beforeInitializeInterface wMaintenanceNoNavigation 
PROCEDURE beforeInitializeInterface :
/*------------------------------------------------------------------------------
  Purpose:     beforeInitializeInterface
  Parameters:  <none>
  Notes:       Override (antes) da inicializaá∆o da tela
------------------------------------------------------------------------------*/

/** inicializa as DBOs **/
run initializeDBOs in this-procedure.

return "OK":U.

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
run converteParaHoraInvertida in {&hDBOTable} (input {&ttTable}.dat-amostra:screen-value in frame fPage0,
                                               input {&ttTable}.hra-amostra:screen-value in frame fPage0,
                                               output HoraInv ).

ASSIGN  {&ttTable}.val-dat-hora-invrtda  = HoraInv. 






return "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE initializeDBOs wMaintenanceNoNavigation 
PROCEDURE initializeDBOs :
/*------------------------------------------------------------------------------
  Purpose:     initializeDBOs
  Parameters:  <none>
  Notes:       Inicializa as BOs no programa
------------------------------------------------------------------------------*/

    /*--- DBO Modelo ---*/
    IF NOT VALID-HANDLE(hDBOModelo) OR
       hDBOModelo:TYPE <> "PROCEDURE":U OR
       hDBOModelo:FILE-NAME <> "frbo/bofr016.p":U THEN DO:
        run frbo/bofr016.p persistent set  hDBOModelo.
    END.
    
    RUN openQueryStatic IN hDBOModelo (INPUT "Main":U) NO-ERROR.

   

/*:T--- Equipamento ---*/   
   IF NOT VALID-HANDLE(hDBOEqpto) OR                                
      hDBOEqpto:TYPE <> "PROCEDURE":U OR                            
      hDBOEqpto:FILE-NAME <> "frbo/bofr007.p":U THEN DO:            
       run frbo/bofr007.p persistent set hDBOEqpto.                 
   END.                                                                
   
    RUN openQueryStatic IN hDBOEqpto (INPUT "Main":U) NO-ERROR.
 
/*:T--- Tipo de Material ---*/   
   IF NOT VALID-HANDLE(hDBOTpMatl) OR                                
      hDBOTpMatl:TYPE <> "PROCEDURE":U OR                            
      hDBOTpMatl:FILE-NAME <> "frbo/bofr026.p":U THEN DO:            
       run frbo/bofr026.p persistent set hDBOTpMatl.       
          
   END.     
   
    RUN openQueryStatic IN hDBOTpMatl (INPUT "Main":U) NO-ERROR.

/*:T--- Compartimento ---*/   
   IF NOT VALID-HANDLE(hDBOCompto) OR                                
      hDBOCompto:TYPE <> "PROCEDURE":U OR                            
      hDBOCompto:FILE-NAME <> "frbo/bofr003.p":U THEN DO:            
       run frbo/bofr003.p persistent set hDBOCompto.                 
   END.  

    RUN openQueryStatic IN hDBOCompto (INPUT "Main":U) NO-ERROR.


/*:T--- Evento ---*/   
   IF NOT VALID-HANDLE(hDBOEvento) OR                                
      hDBOEvento:TYPE <> "PROCEDURE":U OR                            
      hDBOEvento:FILE-NAME <> "frbo/bofr010.p":U THEN DO:            
       run frbo/bofr010.p persistent set hDBOEvento.                 
   END.  

    RUN openQueryStatic IN hDBOEvento (INPUT "Main":U) NO-ERROR.

  /*:T--- Lubrificaá∆o ---*/
    IF NOT VALID-HANDLE(hDBOLubrific) OR
       hDBOLubrific:TYPE <> "PROCEDURE":U OR
       hDBOLubrific:FILE-NAME <> "frbo/bofr058.p":U THEN DO:
        run frbo/bofr058.p persistent set hDBOLubrific.
    END.
    
    RUN openQueryStatic IN hDBOLubrific (INPUT "Main":U) NO-ERROR.
    


                                                              
return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piFocoInicial wMaintenanceNoNavigation 
PROCEDURE piFocoInicial :
/*------------------------------------------------------------------------------
  Purpose:     piFocoInicial
  Parameters:  <none>
  Notes:       Coloca cursor no primeiro campo da tela habilitado
------------------------------------------------------------------------------*/

if pcAction = "ADD":U  or
   pcAction = "COPY":U then
    apply "ENTRY":U to {&ttTable}.dat-amostra in frame fPage0.
else 
    apply "ENTRY":U to {&ttTable}.ep-codigo in frame fPage1.

return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piLeaveCampos wMaintenanceNoNavigation 
PROCEDURE piLeaveCampos :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
if input frame fPage1 {&ttTable}.num-docto <> 0      AND 
                                  c-return = "OK":U then do:
    /**** Desabilita os campos para que o usu†rio n∆o posso modificar
       deve pegar as informaá‰es da ficha de lubrificaá∆o        ****/
    assign  {&ttTable}.cod-comptmento:sensitive in frame fPage1 = no
            {&ttTable}.cod-eqpto:sensitive in frame fPage1      = no
            {&ttTable}.cod-evento:sensitive in frame fPage1     = no
            {&ttTable}.cod-tip-mater:sensitive in frame fPage1  = no
            {&ttTable}.ep-codigo:sensitive in frame fPage1      = no
            {&tttable}.it-codigo:sensitive in frame fPage1      = no.
end.
else do:
    assign  {&ttTable}.cod-comptmento:sensitive in frame fPage1    = yes
            {&ttTable}.cod-eqpto:sensitive in frame fPage1         = yes
            {&ttTable}.cod-evento:sensitive in frame fPage1        = yes
            {&ttTable}.cod-tip-mater:sensitive in frame fPage1     = yes
            {&ttTable}.ep-codigo:sensitive in frame fPage1         = yes
            {&tttable}.it-codigo:sensitive in frame fPage1         = YES
            {&ttTable}.cod-comptmento:screen-value in frame fPage1 = string(var-cod-comptmento) 
            {&ttTable}.cod-eqpto:screen-value in frame fPage1      = string(var-cod-eqpto)
            {&ttTable}.cod-evento:screen-value in frame fPage1     = string(var-cod-evento)
            {&ttTable}.cod-tip-mater:screen-value in frame fPage1  = string(var-cod-tip-mater)
            {&ttTable}.ep-codigo:screen-value in frame fPage1      = STRING(var-ep-codigo)
            {&tttable}.it-codigo:screen-value in frame fPage1      = STRING(var-it-codigo).
end.

/** Descriá‰es de campos **/
    apply "LEAVE":U to {&ttTable}.cod-comptmento in frame fPage1.
    apply "LEAVE":U to {&ttTable}.cod-eqpto      in frame fPage1.
    apply "LEAVE":U to {&ttTable}.cod-tip-mater  in frame fPage1.
    apply "LEAVE":U to {&ttTable}.cod-evento     in frame fPage1.

return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piMostraErros wMaintenanceNoNavigation 
PROCEDURE piMostraErros :
/*------------------------------------------------------------------------------
  Purpose:     piMostraErros
  Parameters:  <none>
  Notes:       Verifica a temp-table de erros da BO e mostra em tela as mensagens
------------------------------------------------------------------------------*/

/** Instancia aplicativo **/
{method/showmessage.i1}
/** Busca erros na BO **/
run getRowErrors in {&hDBOTable} (output table RowErrors).
/** Mostra caixa com erros **/
{method/showmessage.i2 &Modal="YES"}
/** Limpa temp-tables de erros **/
run emptyRowErrors in {&hDBOTable}.

return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piMostraHorario wMaintenanceNoNavigation 
PROCEDURE piMostraHorario :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/


/** Busca a hora atual **/
run piFormataSegundoParaHora (input  time,
                              output {&ttTable}.hra-amostra).

disp {&ttTable}.hra-amostra
    with frame fPage0.

return "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piSituacao wMaintenanceNoNavigation 
PROCEDURE piSituacao :
/*------------------------------------------------------------------------------
  Purpose:     piSituacao
  Parameters:  <none>
  Notes:       Leave do campo Situaá∆o Equipamento
------------------------------------------------------------------------------*/
/*
run buscaSituacao in {&hDBOTable} (input  ttEqpto.cod-sit-eqpto:screen-value in frame fPage1,
                                   output iSituacao).
case iSituacao:
    when 1 then do:   /** Ativo **/
        assign ttEqpto.dat-situacao = ?
               ttEqpto.dat-situacao:sensitive in frame fPage1 = no.
        disp ttEqpto.dat-situacao
            with frame fPage1.        
    end.
    otherwise do:     /** Inativo ou n∆o encontrado **/
        IF ttEqpto.dat-situacao = ? THEN assign ttEqpto.dat-situacao = today.
        ASSIGN ttEqpto.dat-situacao:sensitive in   frame fPage1 = yes.
        DISPLAY ttEqpto.dat-situacao          with frame fPage1.        
    end.
end case.
        */
return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

