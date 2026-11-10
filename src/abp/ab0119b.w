&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME wWindow
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS wWindow 
/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i AB0119B 2.00.00.002 } /*** 010002 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i ab0119b MAB}
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
&GLOBAL-DEFINE Program        AB0119B
&GLOBAL-DEFINE Version        2.00.00.002

&GLOBAL-DEFINE WindowType     Detail

&GLOBAL-DEFINE Folder         NO
&GLOBAL-DEFINE InitialPage    1
&GLOBAL-DEFINE FolderLabels   nada

&GLOBAL-DEFINE page0Widgets   btOK btCancel btHelp2

&GLOBAL-DEFINE page1Widgets fEpCodigoOrigem fCodEqptoOrigem ~
                              fEpCodigoDestino fCodEqptoDestino

/* Parameters Definitions ---                                           */

DEFINE INPUT PARAM p-ep-codigo AS CHAR NO-UNDO.
DEFINE INPUT PARAM p-cod-eqpto AS CHAR NO-UNDO.
DEFINE OUTPUT PARAM p-rowid AS ROWID NO-UNDO.
/* Local Variable Definitions ---                                       */

DEFINE VARIABLE hDBOEquipamento AS HANDLE NO-UNDO.
DEFINE VARIABLE hDBOModel AS HANDLE NO-UNDO.


   DEF VAR c-cod-model NO-UNDO LIKE mab-eqpto.cod-model.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fpage0

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS rtToolBar btOK btCancel btHelp2 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR wWindow AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON btCancel 
     LABEL "&Cancelar" 
     SIZE 10 BY 1.

DEFINE BUTTON btHelp2 
     LABEL "&Ajuda" 
     SIZE 10 BY 1.

DEFINE BUTTON btOK 
     LABEL "&OK" 
     SIZE 10 BY 1.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE  
     SIZE 90 BY 1.42
     BGCOLOR 7 .

DEFINE VARIABLE fCodEqptoDestino AS CHARACTER FORMAT "X(16)":U 
     VIEW-AS FILL-IN 
     SIZE 11 BY .88 NO-UNDO.

DEFINE VARIABLE fCodEqptoOrigem AS CHARACTER FORMAT "X(16)":U 
     VIEW-AS FILL-IN 
     SIZE 11 BY .88 NO-UNDO.

DEFINE VARIABLE fDesModeloDestino AS CHARACTER FORMAT "X(40)":U 
     VIEW-AS FILL-IN 
     SIZE 50 BY .88 NO-UNDO.

DEFINE VARIABLE fDesModeloOrigem AS CHARACTER FORMAT "X(40)":U 
     VIEW-AS FILL-IN 
     SIZE 50 BY .88 NO-UNDO.

DEFINE VARIABLE fEpCodigoDestino AS INTEGER FORMAT ">>9":U INITIAL 0 
     LABEL "Equipamento" 
     VIEW-AS FILL-IN 
     SIZE 5 BY .88 NO-UNDO.

DEFINE VARIABLE fEpCodigoOrigem AS INTEGER FORMAT ">>9":U INITIAL 0 
     LABEL "Equipamento" 
     VIEW-AS FILL-IN 
     SIZE 5 BY .88 NO-UNDO.

DEFINE VARIABLE fiDestino AS CHARACTER FORMAT "X(30)":U INITIAL "Destino" 
      VIEW-AS TEXT 
     SIZE 6 BY .67 NO-UNDO.

DEFINE VARIABLE fiOrigem AS CHARACTER FORMAT "X(30)":U INITIAL "Origem" 
      VIEW-AS TEXT 
     SIZE 6 BY .67 NO-UNDO.

DEFINE RECTANGLE RECT-6
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 82 BY 1.79.

DEFINE RECTANGLE RECT-7
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 82 BY 1.75.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fpage0
     btOK AT ROW 6.71 COL 2
     btCancel AT ROW 6.71 COL 13
     btHelp2 AT ROW 6.71 COL 80
     rtToolBar AT ROW 6.5 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1.04
         SIZE 90 BY 7
         FONT 1.

DEFINE FRAME fPage1
     fEpCodigoOrigem AT ROW 2 COL 11 COLON-ALIGNED
     fCodEqptoOrigem AT ROW 2 COL 16.14 COLON-ALIGNED NO-LABEL
     fDesModeloOrigem AT ROW 2 COL 27.43 COLON-ALIGNED NO-LABEL
     fEpCodigoDestino AT ROW 4.25 COL 11 COLON-ALIGNED
     fCodEqptoDestino AT ROW 4.25 COL 16.14 COLON-ALIGNED NO-LABEL
     fDesModeloDestino AT ROW 4.25 COL 27.43 COLON-ALIGNED NO-LABEL
     fiOrigem AT ROW 1.25 COL 1 COLON-ALIGNED NO-LABEL
     fiDestino AT ROW 3.46 COL 3 NO-LABEL
     RECT-6 AT ROW 1.46 COL 2
     RECT-7 AT ROW 3.75 COL 2
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.57 ROW 1.25
         SIZE 84.43 BY 5
         FONT 1.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Window
   Allow: Basic,Browse,DB-Fields,Window,Query
   Add Fields to: Neither
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW wWindow ASSIGN
         HIDDEN             = YES
         TITLE              = ""
         HEIGHT             = 7.08
         WIDTH              = 90.14
         MAX-HEIGHT         = 27.83
         MAX-WIDTH          = 146.29
         VIRTUAL-HEIGHT     = 27.83
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB wWindow 
/* ************************* Included-Libraries *********************** */

{window/window.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW wWindow
  NOT-VISIBLE,,RUN-PERSISTENT                                           */
/* REPARENT FRAME */
ASSIGN FRAME fPage1:FRAME = FRAME fpage0:HANDLE.

/* SETTINGS FOR FRAME fpage0
   FRAME-NAME                                                           */
/* SETTINGS FOR FRAME fPage1
                                                                        */
ASSIGN 
       fDesModeloDestino:READ-ONLY IN FRAME fPage1        = TRUE.

ASSIGN 
       fDesModeloOrigem:READ-ONLY IN FRAME fPage1        = TRUE.

/* SETTINGS FOR FILL-IN fiDestino IN FRAME fPage1
   ALIGN-L                                                              */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wWindow)
THEN wWindow:HIDDEN = yes.

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

&Scoped-define SELF-NAME wWindow
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wWindow wWindow
ON END-ERROR OF wWindow
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wWindow wWindow
ON WINDOW-CLOSE OF wWindow
DO:
  /* This event will close the window and terminate the procedure.  */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btCancel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btCancel wWindow
ON CHOOSE OF btCancel IN FRAME fpage0 /* Cancelar */
DO:
    APPLY "CLOSE":U TO THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btHelp2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btHelp2 wWindow
ON CHOOSE OF btHelp2 IN FRAME fpage0 /* Ajuda */
DO:
    {include/ajuda.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btOK
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btOK wWindow
ON CHOOSE OF btOK IN FRAME fpage0 /* OK */
DO:
    /** in¡cio das valida‡äes de tela **/
    /** Empresa Origem = 0 **/
    IF INPUT FRAME fPage1 fEpCodigoOrigem = 0 THEN DO:
        {utp/ut-liter.i Origem  * }
        RUN utp/ut-msgs.p (INPUT "SHOW":U, 
                           INPUT 31335,
                           INPUT RETURN-VALUE).
        RETURN NO-APPLY.
    END.
    /** Equipamento Origem = Branco **/
    IF INPUT FRAME fPage1 fCodEqptoOrigem = "" THEN DO:
        /* Inicio -- Projeto Internacional */
        {utp/ut-liter.i "Origem" *}
        RUN utp/ut-msgs.p (INPUT "SHOW":U, 
                           INPUT 31336,
                           INPUT RETURN-VALUE).
        RETURN NO-APPLY.
    END.
    /** Empresa Destino = 0 **/
    IF INPUT FRAME fPage1 fEpCodigoDestino = 0 THEN DO:
        {utp/ut-liter.i Destino * }
        RUN utp/ut-msgs.p (INPUT "SHOW":U, 
                           INPUT 31335,
                           INPUT RETURN-VALUE).
        RETURN NO-APPLY.
    END.
    /** Equipamento Destino = Branco **/
    IF INPUT FRAME fPage1 fCodEqptoDestino = "" THEN DO:
        {utp/ut-liter.i Destino * }
        RUN utp/ut-msgs.p (INPUT "SHOW":U, 
                           INPUT 31336,
                           INPUT RETURN-VALUE).
        RETURN NO-APPLY.
    END.
    /** Equipamento Origem = Equipamento Destino **/
    IF           (INPUT FRAME fPage1 fEpCodigoOrigem = INPUT FRAME fPage1 fEpCodigoDestino) AND
       (fCodEqptoOrigem:SCREEN-VALUE IN FRAME fPage1 = fCodEqptoDestino:SCREEN-VALUE IN FRAME fPage1) THEN DO:
        RUN utp/ut-msgs.p (INPUT "SHOW":U,
                           INPUT 31337,
                           INPUT (INPUT FRAME fPage1 fEpCodigoOrigem + "-" + fCodEqptoOrigem:SCREEN-VALUE IN FRAME fPage1) +
                                  "~~" +
                                 (INPUT FRAME fPage1 fEpCodigoDestino + "-" + fCodEqptoDestino:SCREEN-VALUE IN FRAME fPage1)).
        RETURN NO-APPLY.
    END.
    /** Equipamento Origem NÆo Encontrado **/
    IF NOT CAN-FIND(FIRST mab-eqpto WHERE
                          mab-eqpto.ep-codigo = INPUT FRAME fPage1 fEpCodigoOrigem AND
                          mab-eqpto.cod-eqpto = fCodEqptoOrigem:SCREEN-VALUE IN FRAME fPage1) THEN DO:
        RUN utp/ut-msgs.p (INPUT "SHOW":U,
                           INPUT 31338,
                           INPUT "":U).
        RETURN NO-APPLY.
    END.
    /** Equipamento Destino NÆo Encontrado **/
    IF NOT CAN-FIND(FIRST mab-eqpto WHERE
                          mab-eqpto.ep-codigo = INPUT FRAME fPage1 fEpCodigoDestino AND
                          mab-eqpto.cod-eqpto = fCodEqptoDestino:SCREEN-VALUE IN FRAME fPage1) THEN DO:
        RUN utp/ut-msgs.p (INPUT "SHOW":U,
                           INPUT 31339,
                           INPUT "":U).
        RETURN NO-APPLY.
    END.
    /** fim das valida‡äes de tela **/

       /*** Liga a ampulheta ***/
   if  session:set-wait-state('general':U) then do:
   end /* if */.

   RUN emptyRowErrors    IN hDBOEquipamento.
   RUN copiaRelacSubsist IN hDBOEquipamento (INPUT INPUT FRAME fPage1 fEpCodigoOrigem,
                                             INPUT fCodEqptoOrigem:SCREEN-VALUE IN FRAME fpage1,
                                             INPUT INPUT FRAME fPage1 fEpCodigoDestino,
                                             INPUT fCodEqptoDestino:SCREEN-VALUE IN FRAME fpage1). 
   
   RUN getRowid IN hDBOEquipamento (OUTPUT p-rowid).

   /*** Desliga a ampulheta ***/
   if  session:set-wait-state('':U) then do:
   end /* if */.

   if return-value = "OK" then do:
   /*** assign gr-modelo  = r-Rowid. ***/
      apply "close" to this-procedure. 
   end.
   else do:
      RUN getRowErrors IN hDBOEquipamento (OUTPUT TABLE RowErrors).
      {method/showmessage.i1}
      {method/showmessage.i2}
   end.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage1
&Scoped-define SELF-NAME fCodEqptoDestino
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fCodEqptoDestino wWindow
ON F5 OF fCodEqptoDestino IN FRAME fPage1
DO:
     {method/zoomfields.i 
      &ProgramZoom="frzoom/z01fr007.w"
      &FieldZoom1="ep-codigo"
      &FieldScreen1="fEpCodigoDestino"
      &Frame1="fPage1"
      &FieldZoom2="cod-eqpto"
      &FieldScreen2="fCodEqptoDestino"
      &Frame2="fPage1"
      &EnableImplant="yes"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fCodEqptoDestino wWindow
ON LEAVE OF fCodEqptoDestino IN FRAME fPage1
DO:
         
   RUN goToKey IN hDBOEquipamento (INPUT fEpCodigoDestino:SCREEN-VALUE, 
                                   INPUT fCodEqptoDestino:SCREEN-VALUE).
   IF RETURN-VALUE = "OK":U THEN DO:
       RUN getCharField IN hDBOEquipamento (INPUT "cod-model", OUTPUT c-cod-model).
   END.
   ELSE DO:
       ASSIGN c-cod-model = "".
   END.
       {method/ReferenceFields.i
              &HandleDBOLeave="hDBOModel"
              &KeyValue1="c-cod-model"
              &FieldName1="des-model"
              &FieldScreen1="fDesModeloDestino"
              &Frame1="fPage1"}

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fCodEqptoDestino wWindow
ON MOUSE-SELECT-DBLCLICK OF fCodEqptoDestino IN FRAME fPage1
DO:
  APPLY "F5":U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fCodEqptoOrigem
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fCodEqptoOrigem wWindow
ON F5 OF fCodEqptoOrigem IN FRAME fPage1
DO:
    {method/zoomfields.i 
      &ProgramZoom="frzoom/z01fr007.w"
      &FieldZoom1="ep-codigo"
      &FieldScreen1="fEpCodigoOrigem"
      &Frame1="fPage1"
      &FieldZoom2="cod-eqpto"
      &FieldScreen2="fCodEqptoOrigem"
      &Frame2="fPage1"
      &EnableImplant="yes"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fCodEqptoOrigem wWindow
ON LEAVE OF fCodEqptoOrigem IN FRAME fPage1
DO:
   FOR FIRST mab-eqpto WHERE mab-eqpto.ep-codigo = INPUT FRAME fPage1 fEpCodigoOrigem
                         AND mab-eqpto.cod-eqpto = fCodEqptoOrigem:SCREEN-VALUE NO-LOCK:
   END.

   IF NOT AVAIL mab-eqpto THEN DO:
       ASSIGN fDesModeloOrigem:SCREEN-VALUE = "".
       RETURN "NOK":U.
   END.

   RUN goToKey IN hDBOEquipamento (INPUT INPUT FRAME fPage1 fEpCodigoOrigem,
                                   INPUT fCodEqptoOrigem:SCREEN-VALUE).
   RUN getCharField IN hDBOEquipamento (INPUT "cod-model", OUTPUT c-cod-model).

   {method/ReferenceFields.i
          &HandleDBOLeave="hDBOModel"
          &KeyValue1="c-cod-model"
          &FieldName1="des-model"
          &FieldScreen1="fDesModeloOrigem"
          &Frame1="fPage1"}

 END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fCodEqptoOrigem wWindow
ON MOUSE-SELECT-DBLCLICK OF fCodEqptoOrigem IN FRAME fPage1
DO:
  APPLY "F5":U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fCodEqptoOrigem wWindow
ON VALUE-CHANGED OF fCodEqptoOrigem IN FRAME fPage1
DO:
  APPLY "leave":U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fEpCodigoDestino
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fEpCodigoDestino wWindow
ON F5 OF fEpCodigoDestino IN FRAME fPage1 /* Equipamento */
DO:
     {method/zoomfields.i 
      &ProgramZoom="frzoom/z01fr007.w"
      &FieldZoom1="ep-codigo"
      &FieldScreen1="fEpCodigoDestino"
      &Frame1="fPage1"
      &FieldZoom2="cod-eqpto"
      &FieldScreen2="fCodEqptoDestino"
      &Frame2="fPage1"
      &EnableImplant="yes"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fEpCodigoDestino wWindow
ON MOUSE-SELECT-DBLCLICK OF fEpCodigoDestino IN FRAME fPage1 /* Equipamento */
DO:
  APPLY "F5":U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fEpCodigoOrigem
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fEpCodigoOrigem wWindow
ON F5 OF fEpCodigoOrigem IN FRAME fPage1 /* Equipamento */
DO:
     {method/zoomfields.i 
      &ProgramZoom="frzoom/z01fr007.w"
      &FieldZoom1="ep-codigo"
      &FieldScreen1="fEpCodigoOrigem"
      &Frame1="fPage1"
      &FieldZoom2="cod-eqpto"
      &FieldScreen2="fCodEqptoOrigem"
      &Frame2="fPage1"
      &EnableImplant="yes"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fEpCodigoOrigem wWindow
ON MOUSE-SELECT-DBLCLICK OF fEpCodigoOrigem IN FRAME fPage1 /* Equipamento */
DO:
  APPLY "F5":U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fpage0
&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wWindow 


/*:T--- L¢gica para inicializa‡Æo do programam ---*/

fEpCodigoOrigem:load-mouse-pointer  ("image/lupa.cur") in frame fPage1.
fEpCodigoDestino:load-mouse-pointer ("image/lupa.cur") in frame fPage1.
fCodEqptoOrigem:load-mouse-pointer  ("image/lupa.cur") in frame fPage1.
fCodEqptoDestino:load-mouse-pointer ("image/lupa.cur") in frame fPage1.

{window/mainblock.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterInitializeInterface wWindow 
PROCEDURE afterInitializeInterface :
/*------------------------------------------------------------------------------
  Purpose:     Override ap¢s inicializa‡Æo da tela
  Parameters:  <nenhum>
  Notes:       
------------------------------------------------------------------------------*/
/** Labels de Tela **/
{utp/ut-liter.i Origem * }
ASSIGN fiOrigem:SCREEN-VALUE IN FRAME fPage1 = RETURN-VALUE.
{utp/ut-liter.i Destino * }
ASSIGN fiDestino:SCREEN-VALUE IN FRAME fPage1 = RETURN-VALUE.


/** Inicializa Handles **/
IF NOT VALID-HANDLE(hDBOEquipamento) THEN DO:
    RUN  frbo/bofr007.p PERSISTENT SET  hDBOEquipamento.
END.
    RUN openQueryStatic IN hDBOEquipamento (INPUT "Main":U) NO-ERROR.

IF NOT VALID-HANDLE(hDBOModel) THEN DO:
    RUN  frbo/bofr016.p PERSISTENT SET  hDBOModel.
END.

    RUN openQueryStatic IN hDBOModel (INPUT "Main":U) NO-ERROR.

    ASSIGN fEpCodigoOrigem:SCREEN-VALUE IN FRAME fPage1 = string(p-ep-codigo)
           fCodEqptoOrigem:SCREEN-VALUE IN FRAME fpage1 = p-cod-eqpto.

    APPLY "Leave":U TO fCodEqptoOrigem.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterDestroyInterface wWindow 
PROCEDURE afterDestroyInterface :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
IF VALID-HANDLE (hDBOEquipamento) THEN
   DELETE PROCEDURE hDBOEquipamento.

IF VALID-HANDLE (hDBOModel) THEN
   DELETE PROCEDURE hDBOModel.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
