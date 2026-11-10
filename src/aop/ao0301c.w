&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          movfro           PROGRESS
*/
&Scoped-define WINDOW-NAME wMaintenanceNoNavigation

/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE ttAmostraOleo NO-UNDO LIKE mao-amostra-oleo
       field r-rowid as rowid.
DEFINE TEMP-TABLE ttResultEnsaio NO-UNDO LIKE mao-restdo-ensaio
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
{include/i-prgvrs.i AO0301C 2.00.00.001}  /*** 010001 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i ao0301c MAO}
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
&GLOBAL-DEFINE Program           AO0301C
&GLOBAL-DEFINE Version           2.00.00.001

&GLOBAL-DEFINE Folder            YES
&GLOBAL-DEFINE InitialPage       1


&GLOBAL-DEFINE FolderLabels      Padräes,Observa‡Æo

&GLOBAL-DEFINE ttTable           ttResultEnsaio
&GLOBAL-DEFINE hDBOTable         hDBOResultEnsaio
&GLOBAL-DEFINE DBOTable          mao-restdo-ensaio

&GLOBAL-DEFINE ttParent          ttAmostraOleo
&GLOBAL-DEFINE DBOParentTable    hDBOAmostraOleo

&GLOBAL-DEFINE page0KeyFields     ttResultEnsaio.cod-ensaio
  
&GLOBAL-DEFINE page0Fields       
&GLOBAL-DEFINE page0ParentFields ttAmostraOleo.cod-amostra-fisic ~
                                 ttAmostraOleo.num-amostra-oleo
                                 
                                  
&GLOBAL-DEFINE page1Fields       ttResultEnsaio.num-tabela ~
                                 ttResultEnsaio.log-padrao ~
                                 ttResultEnsaio.des-formato
                                  
                                  

&GLOBAL-DEFINE page2Fields ttResultEnsaio.dsl-obs      
                               

/* Parameters Definitions ---                                           */
DEFINE INPUT PARAMETER prTable         AS ROWID     NO-UNDO.
DEFINE INPUT PARAMETER prParent        AS ROWID     NO-UNDO.
DEFINE INPUT PARAMETER pcAction        AS CHARACTER NO-UNDO.
DEFINE INPUT PARAMETER phCaller        AS HANDLE    NO-UNDO.
DEFINE INPUT PARAMETER piSonPageNumber AS INTEGER   NO-UNDO.

/* Local Variable Definitions ---                                       */
DEFINE VARIABLE iTpResult like mao-ensaio.idi-tip-restdo     NO-UNDO.
/* Local Variable Definitions (DBOs Handles) --- */
DEFINE VARIABLE {&hDBOTable}  AS HANDLE NO-UNDO.
DEFINE VARIABLE hDBOEnsaio    AS HANDLE NO-UNDO.
DEFINE VARIABLE hDBOTabela    AS HANDLE NO-UNDO.

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
ttAmostraOleo.cod-amostra-fisic ttResultEnsaio.cod-ensaio 
&Scoped-define ENABLED-TABLES ttAmostraOleo ttResultEnsaio
&Scoped-define FIRST-ENABLED-TABLE ttAmostraOleo
&Scoped-define SECOND-ENABLED-TABLE ttResultEnsaio
&Scoped-Define ENABLED-OBJECTS fiDescEnsaio btOK btSave btCancel btHelp ~
rtKeys rtToolBar 
&Scoped-Define DISPLAYED-FIELDS ttAmostraOleo.num-amostra-oleo ~
ttAmostraOleo.cod-amostra-fisic ttResultEnsaio.cod-ensaio 
&Scoped-define DISPLAYED-TABLES ttAmostraOleo ttResultEnsaio
&Scoped-define FIRST-DISPLAYED-TABLE ttAmostraOleo
&Scoped-define SECOND-DISPLAYED-TABLE ttResultEnsaio
&Scoped-Define DISPLAYED-OBJECTS fiDescEnsaio 

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

DEFINE VARIABLE fiDescEnsaio AS CHARACTER FORMAT "X(60)":U 
     VIEW-AS FILL-IN 
     SIZE 35 BY .88 NO-UNDO.

DEFINE RECTANGLE rtKeys
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 90 BY 2.5.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE  
     SIZE 90 BY 1.42
     BGCOLOR 7 .

DEFINE VARIABLE fiDescTabela AS CHARACTER FORMAT "X(30)":U 
     VIEW-AS FILL-IN 
     SIZE 54.43 BY .88 NO-UNDO.

DEFINE VARIABLE fiText-3 AS CHARACTER FORMAT "X(256)":U INITIAL "Valores Padräes" 
      VIEW-AS TEXT 
     SIZE 13 BY .63
     FONT 1 NO-UNDO.

DEFINE VARIABLE fiVal-max-dat AS DATE FORMAT "99/99/9999":U 
     VIEW-AS FILL-IN 
     SIZE 25 BY .88 NO-UNDO.

DEFINE VARIABLE fiVal-max-num AS DECIMAL FORMAT "->>>,>>>,>>9.9999":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 25 BY .88 NO-UNDO.

DEFINE VARIABLE fiVal-max-txt AS CHARACTER FORMAT "X(60)":U 
     VIEW-AS FILL-IN 
     SIZE 25 BY .88 NO-UNDO.

DEFINE VARIABLE fiVal-min-dat AS DATE FORMAT "99/99/9999":U 
     LABEL "" 
     VIEW-AS FILL-IN 
     SIZE 25 BY .88 NO-UNDO.

DEFINE VARIABLE fiVal-min-num AS DECIMAL FORMAT "->>>,>>>,>>9.9999":U INITIAL 0 
     LABEL "" 
     VIEW-AS FILL-IN 
     SIZE 25 BY .88 NO-UNDO.

DEFINE VARIABLE fiVal-min-txt AS CHARACTER FORMAT "X(60)":U 
     LABEL "" 
     VIEW-AS FILL-IN 
     SIZE 25 BY .88 NO-UNDO.

DEFINE IMAGE IMAGE-1
     FILENAME "image/im-fir.bmp":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-2
     FILENAME "image/im-las.bmp":U
     SIZE 3 BY .88.

DEFINE RECTANGLE RECT-16
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 70.14 BY 2.25.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fpage0
     fiDescEnsaio AT ROW 2.25 COL 30.14 COLON-ALIGNED NO-LABEL
     btOK AT ROW 17.25 COL 2
     btSave AT ROW 17.25 COL 13
     btCancel AT ROW 17.25 COL 24
     btHelp AT ROW 17.25 COL 80
     ttAmostraOleo.num-amostra-oleo AT ROW 1.25 COL 20 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 10 BY .88
     ttAmostraOleo.cod-amostra-fisic AT ROW 1.25 COL 53.14 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 12 BY .88
     ttResultEnsaio.cod-ensaio AT ROW 2.25 COL 20 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 10 BY .88
     rtKeys AT ROW 1 COL 1
     rtToolBar AT ROW 17 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 90 BY 17.42
         FONT 1.

DEFINE FRAME fPage1
     ttResultEnsaio.log-padrao AT ROW 1.75 COL 14.43
          VIEW-AS TOGGLE-BOX
          SIZE 9.29 BY .71
     ttResultEnsaio.num-tabela AT ROW 2.75 COL 12.43 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 6 BY .88
     fiDescTabela AT ROW 2.75 COL 18.57 COLON-ALIGNED NO-LABEL
     ttResultEnsaio.des-formato AT ROW 3.75 COL 12.43 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 44 BY .88
     fiText-3 AT ROW 5 COL 6.57 COLON-ALIGNED NO-LABEL
     fiVal-min-num AT ROW 6 COL 12.43 COLON-ALIGNED
     fiVal-max-num AT ROW 6 COL 49 COLON-ALIGNED NO-LABEL
     fiVal-min-txt AT ROW 6 COL 12.43 COLON-ALIGNED
     fiVal-max-txt AT ROW 6 COL 49 COLON-ALIGNED NO-LABEL
     fiVal-min-dat AT ROW 6 COL 12.43 COLON-ALIGNED
     fiVal-max-dat AT ROW 6 COL 49 COLON-ALIGNED NO-LABEL
     IMAGE-1 AT ROW 6 COL 40
     IMAGE-2 AT ROW 6 COL 47.57
     RECT-16 AT ROW 5.25 COL 6.86
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.57 ROW 5
         SIZE 84.43 BY 10.71
         FONT 1.

DEFINE FRAME fPage2
     ttResultEnsaio.dsl-obs AT ROW 1.5 COL 2 NO-LABEL
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
      TABLE: ttResultEnsaio T "?" NO-UNDO movfro mao-restdo-ensaio
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

DEFINE VARIABLE XXTABVALXX AS LOGICAL NO-UNDO.

ASSIGN XXTABVALXX = FRAME fPage2:MOVE-AFTER-TAB-ITEM (fiDescEnsaio:HANDLE IN FRAME fpage0)
       XXTABVALXX = FRAME fPage2:MOVE-BEFORE-TAB-ITEM (btOK:HANDLE IN FRAME fpage0)
       XXTABVALXX = FRAME fPage1:MOVE-AFTER-TAB-ITEM (ttResultEnsaio.cod-ensaio:HANDLE IN FRAME fpage0)
/* END-ASSIGN-TABS */.

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
    if return-value = "OK":U then do:
       APPLY "CLOSE":U TO THIS-PROCEDURE.
    end.
    else do:
        return no-apply.
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
    

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME ttResultEnsaio.cod-ensaio
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ttResultEnsaio.cod-ensaio wMaintenanceNoNavigation
ON LEAVE OF ttResultEnsaio.cod-ensaio IN FRAME fpage0 /* Ensaio */
DO:
  {method/referenceFields.i
        &HandleDBOLeave="hDBOEnsaio"
        &KeyValue1="{&ttTable}.cod-ensaio:screen-value in frame fPage0"
        &FieldName1="des-ensaio"
        &FieldScreen1="fiDescEnsaio"
        &Frame1="fPage0"}  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage1
&Scoped-define SELF-NAME ttResultEnsaio.des-formato
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ttResultEnsaio.des-formato wMaintenanceNoNavigation
ON LEAVE OF ttResultEnsaio.des-formato IN FRAME fPage1 /* Formato */
DO:
    IF AVAIL {&ttTable} THEN DO WITH FRAME fpage1:

        DEFINE VARIABLE c-teste AS CHARACTER  NO-UNDO.
        DEFINE VARIABLE i-cont1 AS INTEGER INITIAL 0 NO-UNDO.
        DEFINE VARIABLE i-cont2 AS INTEGER INITIAL 0 NO-UNDO.
        DEFINE VARIABLE c-aux1 AS CHARACTER FORMAT "X(30)" NO-UNDO.
        DEFINE VARIABLE c-aux2 AS CHARACTER FORMAT "X(30)" NO-UNDO.

        CASE iTpResult :
          WHEN 1 THEN DO:
              ASSIGN  fiVal-min-num:FORMAT  = {&ttTable}.des-formato:SCREEN-VALUE
                      fiVal-max-num:FORMAT  = {&ttTable}.des-formato:SCREEN-VALUE NO-ERROR.
              IF error-status:ERROR = NO AND 
                 (fiVal-max-num:SCREEN-VALUE IN FRAME fPage1 = "0" OR
                  fiVal-max-num:SCREEN-VALUE IN FRAME fPage1 = ""  OR 
                  fiVal-max-num:SCREEN-VALUE IN FRAME fPage1 = ?)  THEN DO:

                  /*caso tenha gravado sem erro o formato nos campos de val min e max, e o valor de max seja 0, "" ou nulo
                    entao completar o val max com 999 conforme o formato especificado pelo des-formato */

                  ASSIGN c-teste = ENTRY(2,{&ttTable}.des-formato:SCREEN-VALUE,".") NO-ERROR.
                  IF error-status:ERROR THEN DO:

                      /*caso o formato NÇO seja DECIMAL: */
                      DO WHILE i-cont1 <> LENGTH({&ttTable}.des-formato:SCREEN-VALUE):
                          ASSIGN i-cont1 = i-cont1 + 1.
                          IF SUBSTRING({&ttTable}.des-formato:SCREEN-VALUE,i-cont1,1) = ">" OR 
                             SUBSTRING({&ttTable}.des-formato:SCREEN-VALUE,i-cont1,1) = "9" THEN
                              ASSIGN i-cont2 = i-cont2 + 1.
                      END.
                      ASSIGN fiVal-max-num:SCREEN-VALUE = FILL("9", i-cont2).

                  END.
                  ELSE DO: /*caso seja DECIMAL*/

                      DO WHILE i-cont1 <> LENGTH(ENTRY(1,{&ttTable}.des-formato:SCREEN-VALUE,".")):
                          ASSIGN i-cont1 = i-cont1 + 1.
                          IF SUBSTRING(ENTRY(1,{&ttTable}.des-formato:SCREEN-VALUE,"."),i-cont1,1) = ">" OR 
                             SUBSTRING(ENTRY(1,{&ttTable}.des-formato:SCREEN-VALUE,"."),i-cont1,1) = "9" THEN
                              ASSIGN i-cont2 = i-cont2 + 1.
                      END.
                      ASSIGN c-aux1 = FILL("9",i-cont2).

                      ASSIGN i-cont1 = 0
                             i-cont2 = 0.

                      DO WHILE i-cont1 <> LENGTH(ENTRY(2,{&ttTable}.des-formato:SCREEN-VALUE,".")):
                          ASSIGN i-cont1 = i-cont1 + 1.
                          IF SUBSTRING(ENTRY(2,{&ttTable}.des-formato:SCREEN-VALUE,"."),i-cont1,1) = ">" OR 
                             SUBSTRING(ENTRY(2,{&ttTable}.des-formato:SCREEN-VALUE,"."),i-cont1,1) = "9" THEN
                              ASSIGN i-cont2 = i-cont2 + 1.
                      END.
                      ASSIGN c-aux2 = FILL("9",i-cont2).

                      ASSIGN fiVal-max-num:SCREEN-VALUE = STRING(c-aux1 + "," + c-aux2).

                  END. /*else*/

              END. /* IF error-status:ERROR = NO*/

          END. /*when 1*/
        WHEN 3 THEN DO:
            ASSIGN fiVal-min-txt:FORMAT  = {&ttTable}.des-formato:SCREEN-VALUE           
                   fiVal-max-txt:FORMAT  = {&ttTable}.des-formato:SCREEN-VALUE NO-ERROR.

        END. /*when 3*/
      END CASE.
    END. /*if avail*/  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME ttResultEnsaio.num-tabela
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ttResultEnsaio.num-tabela wMaintenanceNoNavigation
ON LEAVE OF ttResultEnsaio.num-tabela IN FRAME fPage1 /* Tabela */
DO:
  {method/referenceFields.i
        &HandleDBOLeave="hDBOTabela"
        &KeyValue1="{&ttTable}.num-tabela:screen-value in frame fPage1"
        &FieldName1="des-tabela"
        &FieldScreen1="fiDescTabela"
        &Frame1="fPage1"}  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ttResultEnsaio.num-tabela wMaintenanceNoNavigation
ON MOUSE-SELECT-DBLCLICK OF ttResultEnsaio.num-tabela IN FRAME fPage1 /* Tabela */
OR "F5":U OF {&ttTable}.num-tabela IN FRAME fPage1 DO:
        {method/zoomfields.i 
           &ProgramZoom="frzoom/z01fr102.w"
           &FieldZoom1="num-tabela"
           &FieldScreen1="{&ttTable}.num-tabela"
           &Frame1="fPage1"
           &FieldZoom2="des-tabela"
           &FieldScreen2="fiDescTabela"
           &Frame2="fPage1"
           &EnableImplant="YES"}    
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fpage0
&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wMaintenanceNoNavigation 


/*:T--- L¢gica para inicializa‡Æo do programam ---*/
{maintenancenonavigation/mainblock.i}

{&ttTable}.num-tabela:LOAD-MOUSE-POINTER("image/lupa.cur":U) in frame fPage1.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterDestroyInterface wMaintenanceNoNavigation 
PROCEDURE afterDestroyInterface :
/*------------------------------------------------------------------------------
  Purpose:     afterDestroyInterface
  Parameters:  <none>
  Notes:       Override (ap¢s) a finaliza‡Æo do programa
------------------------------------------------------------------------------*/
/** Ensaio **/
if valid-handle(hDBOEnsaio) then
    run destroy in hDBOEnsaio.


/** Tabela **/
if valid-handle(hDBOTabela) then
    run destroy in hDBOTabela.

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
    /** Descri‡äes de campos **/
    apply "LEAVE":U to {&ttTable}.num-tabela     in frame fPage1.
    apply "LEAVE":U to {&ttTable}.cod-ensaio     in frame fPage0.

end.
else do:
  assign fiDescTabela:screen-value in frame fPage1  = "":U
         fiDescEnsaio:screen-value in frame fPage0  = "":U.

end.
/***** Verifica tipo de resultado associado ao Ensaio ***/
RUN goToKey      IN hDBOEnsaio (input frame fPage0 {&ttTable}.cod-ensaio).
if return-value = "OK":U then do:
    RUN getIntField  IN hDBOEnsaio  (input "idi-tip-restdo":U,output iTpResult).
    if pcAction = "UPDATE":U 
       or pcAction = "ADD":U 
       or pcAction = "COPY":U then do:
       case iTpResult:
            when 1 then do: /*numero*/
              assign {&ttTable}.num-tabela:sensitive in frame fPage1  = no
                     {&ttTable}.des-formato:sensitive in frame fPage1 = YES
                     {&ttTable}.num-tabela:SCREEN-VALUE in frame fPage1  = "0"
                     fiDescTabela:SCREEN-VALUE in frame fPage1        = ""
                     fiVal-min-dat:sensitive in frame fPage1          = no
                     fiVal-min-txt:sensitive in frame fPage1          = no
                     fiVal-min-num:sensitive in frame fPage1          = yes
                     fiVal-min-dat:hidden in frame fPage1             = yes
                     fiVal-min-txt:hidden in frame fPage1             = yes
                     fiVal-min-num:hidden in frame fPage1             = no
                     fiVal-max-dat:sensitive in frame fPage1          = no
                     fiVal-max-txt:sensitive in frame fPage1          = no
                     fiVal-max-num:sensitive in frame fPage1          = yes
                     fiVal-max-dat:hidden in frame fPage1             = yes
                     fiVal-max-txt:hidden in frame fPage1             = yes
                     fiVal-max-num:hidden in frame fPage1             = no
                     fiVal-min-num                                    = dec({&ttTable}.des-val-min)
                     fiVal-max-num                                    = dec({&ttTable}.des-val-max).

                     disp fiVal-max-num
                          fiVal-min-num with frame fPage1.
           end.
           when 2 then do: /*tabela*/
              assign {&ttTable}.num-tabela:sensitive in frame fPage1  = yes
                     {&ttTable}.des-formato:sensitive in frame fPage1 = NO
                     {&ttTable}.des-formato:SCREEN-VALUE in frame fPage1 = ""
                     fiVal-min-dat:sensitive in frame fPage1          = no
                     fiVal-min-txt:sensitive in frame fPage1          = no
                     fiVal-min-num:sensitive in frame fPage1          = no
                     fiVal-min-dat:hidden in frame fPage1             = yes
                     fiVal-min-txt:hidden in frame fPage1             = no
                     fiVal-min-num:hidden in frame fPage1             = yes
                     fiVal-max-dat:sensitive in frame fPage1          = no
                     fiVal-max-txt:sensitive in frame fPage1          = no
                     fiVal-max-num:sensitive in frame fPage1          = no
                     fiVal-max-dat:hidden in frame fPage1             = yes
                     fiVal-max-txt:hidden in frame fPage1             = no
                     fiVal-max-num:hidden in frame fPage1             = yes
                     fiVal-max-txt:screen-value in frame fPage1       = ""
                     fiVal-min-txt:screen-value in frame fPage1       = "".

              DISP {&ttTable}.num-tabela WITH FRAME fPage1.
              apply "LEAVE":U to {&ttTable}.num-tabela     in frame fPage1.
              
           end.
            when 3 then do: /*texto*/
              assign {&ttTable}.num-tabela:sensitive in frame fPage1  = NO
                     {&ttTable}.des-formato:sensitive in frame fPage1 = YES
                     {&ttTable}.num-tabela:SCREEN-VALUE in frame fPage1  = "0"
                     fiDescTabela:SCREEN-VALUE in frame fPage1        = ""
                     fiVal-min-dat:sensitive in frame fPage1          = no
                     fiVal-min-txt:sensitive in frame fPage1          = yes
                     fiVal-min-num:sensitive in frame fPage1          = no
                     fiVal-min-dat:hidden in frame fPage1             = yes
                     fiVal-min-txt:hidden in frame fPage1             = no
                     fiVal-min-num:hidden in frame fPage1             = yes
                     fiVal-max-dat:sensitive in frame fPage1          = no
                     fiVal-max-txt:sensitive in frame fPage1          = yes
                     fiVal-max-num:sensitive in frame fPage1          = no
                     fiVal-max-dat:hidden in frame fPage1             = yes
                     fiVal-max-txt:hidden in frame fPage1             = no
                     fiVal-max-num:hidden in frame fPage1             = yes
                     fiVal-min-txt                                    = string({&ttTable}.des-val-min)
                     fiVal-max-txt                                    = string({&ttTable}.des-val-max).
    
                      disp fiVal-max-txt
                           fiVal-min-txt with frame fPage1.
              
           end.
           when 4 then do: /*data*/
              assign {&ttTable}.num-tabela:sensitive in frame fPage1  = no
                     {&ttTable}.des-formato:sensitive in frame fPage1 = NO
                     {&ttTable}.num-tabela:SCREEN-VALUE in frame fPage1  = "0"
                     fiDescTabela:SCREEN-VALUE in frame fPage1        = ""
                     fiVal-min-dat:sensitive in frame fPage1          = yes
                     fiVal-min-txt:sensitive in frame fPage1          = no
                     fiVal-min-num:sensitive in frame fPage1          = yes
                     fiVal-min-dat:hidden in frame fPage1             = no
                     fiVal-min-txt:hidden in frame fPage1             = yes
                     fiVal-min-num:hidden in frame fPage1             = yes
                     fiVal-max-dat:sensitive in frame fPage1          = yes
                     fiVal-max-txt:sensitive in frame fPage1          = no
                     fiVal-max-num:sensitive in frame fPage1          = no
                     fiVal-max-dat:hidden in frame fPage1             = no
                     fiVal-max-txt:hidden in frame fPage1             = yes
                     fiVal-max-num:hidden in frame fPage1             = yes
                     fiVal-min-dat                                    = date({&ttTable}.des-val-min)
                     fiVal-max-dat                                    = date({&ttTable}.des-val-max).
    
                      disp fiVal-max-dat
                           fiVal-min-dat with frame fPage1.
              
           end.
       end case.
    end.
end.

APPLY "leave":U TO ttResultEnsaio.des-formato IN FRAME fPage1.

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
  Notes:       Override (Ap¢s) inicializa‡Æo da tela
------------------------------------------------------------------------------*/

{utp/ut-liter.i Valores_padräes }
assign fiText-3 = trim(return-value).
disp fiText-3 with frame fPage1.

/** Seta foco no campo correto **/
run afterDisplayFields in this-procedure.


{utp/ut-liter.i Faixa *  }
assign fiVal-min-dat:label in frame fPage1 = trim(return-value)
       fiVal-min-txt:label in frame fPage1 = trim(return-value)
       fiVal-min-num:label in frame fPage1 = trim(return-value).


/***** Verifica tipo de resultado associado ao Ensaio ***/
RUN goToKey      IN hDBOEnsaio (input frame fPage0 {&ttTable}.cod-ensaio).
if return-value = "OK":U then do:
    RUN getIntField  IN hDBOEnsaio (input "idi-tip-restdo":U, output iTpResult).
end.

apply "ENTRY":U to  {&ttTable}.log-padrao in frame fPage1.

RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE beforeInitializeInterface wMaintenanceNoNavigation 
PROCEDURE beforeInitializeInterface :
/*------------------------------------------------------------------------------
  Purpose:     beforeInitializeInterface
  Parameters:  <none>
  Notes:       Override (antes) da inicializa‡Æo da tela
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
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

if pcAction = "UPDATE":U 
   or pcAction = "ADD":U 
   or pcAction = "COPY":U then do:
   case iTpResult:
        when 1 then do:
          assign  {&ttTable}.des-formato  =   string({&ttTable}.des-formato:screen-value in frame fPage1)                  
                  {&ttTable}.des-val-max  =   string(fiVal-max-num:screen-value in frame fPage1)                   
                  {&ttTable}.des-val-min  =   string(fiVal-min-num:screen-value in frame fPage1).                
       end.
       when 2 then do:
          assign  {&ttTable}.des-formato  =   string({&ttTable}.des-formato:screen-value in frame fPage1)    
                  {&ttTable}.des-val-max  =   ""                   
                  {&ttTable}.des-val-min  =   "".                
       end.
       when 3 then do:
          assign  {&ttTable}.des-formato  =   string({&ttTable}.des-formato:screen-value in frame fPage1)                  
                  {&ttTable}.des-val-max  =   string(fiVal-max-txt:screen-value in frame fPage1)                   
                  {&ttTable}.des-val-min  =   string(fiVal-min-txt:screen-value in frame fPage1).                
       end.
       when 4 then do:
          assign  {&ttTable}.des-formato  =   string({&ttTable}.des-formato:screen-value in frame fPage1)                  
                  {&ttTable}.des-val-max  =   string(fiVal-max-dat:screen-value in frame fPage1)                   
                  {&ttTable}.des-val-min  =   string(fiVal-min-dat:screen-value in frame fPage1).                
       end.
   end case.
   assign {&ttTable}.log-padrao = {&ttTable}.log-padrao:checked in frame fPage1.
   

end.

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

    /*--- DBO Ensaio ---*/
    IF NOT VALID-HANDLE(hDBOEnsaio) OR
       hDBOEnsaio:TYPE <> "PROCEDURE":U OR
       hDBOEnsaio:FILE-NAME <> "frbo/bofr103.p":U THEN DO:
        run frbo/bofr103.p persistent set  hDBOEnsaio.
    END.
    
    RUN openQueryStatic IN hDBOEnsaio (INPUT "Main":U) NO-ERROR.

   

/*:T--- Tabela ---*/   
   IF NOT VALID-HANDLE(hDBOTabela) OR                                
      hDBOTabela:TYPE <> "PROCEDURE":U OR                            
      hDBOTabela:FILE-NAME <> "frbo/bofr102.p":U THEN DO:            
       run frbo/bofr102.p persistent set hDBOTabela.                 
   END.                                                                
   
    RUN openQueryStatic IN hDBOTabela (INPUT "Main":U) NO-ERROR.
 
    


                                                              
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
    apply "ENTRY":U to {&ttTable}.log-padrao in frame fPage1.

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
FOR EACH RowErrors WHERE RowErrors.ErrorSubType <> "ERROR":U EXCLUSIVE-LOCK:
    DELETE RowErrors.
END.
/** Mostra caixa com erros **/
{method/showmessage.i2 &Modal="YES"}
/** Limpa temp-tables de erros **/
run emptyRowErrors in {&hDBOTable}.

return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

