&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME C-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS C-Win 
/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i BCAPI014 2.00.00.005} /*** "010005" 17/10/2023 18:26:04  ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i BCAPI014 MUT}
&ENDIF


/*------------------------------------------------------------------------

  File: 

  Description: 

  Input Parameters:
      <none>

  Output Parameters:
      <none>

  Author: 

  Created: 

------------------------------------------------------------------------*/
/*          This .W file was created with the Progress AppBuilder.      */
/*----------------------------------------------------------------------*/

/* Create an unnamed pool to store all the widgets created 
     by this procedure. This is a good default which assures
     that this procedure's triggers and internal procedures 
     will execute in this procedure's storage, and that proper
     cleanup will occur on deletion of the procedure. */

CREATE WIDGET-POOL.

/* ***************************  Definitions  ************************** */

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

DEFINE VARIABLE vNumCommPort        AS INTEGER   NO-UNDO.
DEFINE VARIABLE vNumBitsPerSecond   AS INTEGER   NO-UNDO.
DEFINE VARIABLE vNumDataBits        AS INTEGER   NO-UNDO.
DEFINE VARIABLE vDesParity          AS CHARACTER NO-UNDO.
DEFINE VARIABLE vNumStopBits        AS INTEGER   NO-UNDO.
DEFINE VARIABLE vDesFlowControl     AS CHARACTER NO-UNDO.
DEFINE VARIABLE vDesParameterFile   AS CHARACTER NO-UNDO.
DEFINE VARIABLE vDesLine            AS CHARACTER NO-UNDO.
DEFINE VARIABLE vDesBuffer          AS CHARACTER NO-UNDO.
DEFINE VARIABLE vDesBufferReg       AS CHARACTER NO-UNDO.
DEFINE VARIABLE vDesSettings        AS CHARACTER NO-UNDO.
DEFINE VARIABLE vCodError           AS INTEGER   NO-UNDO.
DEFINE VARIABLE vdefinefileini      AS CHARACTER NO-UNDO.

DEFINE STREAM stParam.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME fComm

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS vDesStatus vDesData IMAGE-1 
&Scoped-Define DISPLAYED-OBJECTS vDesStatus vDesData 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR C-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of handles for OCX Containers                            */
DEFINE VARIABLE Comm AS WIDGET-HANDLE NO-UNDO.
DEFINE VARIABLE chComm AS COMPONENT-HANDLE NO-UNDO.
DEFINE VARIABLE Timer AS WIDGET-HANDLE NO-UNDO.
DEFINE VARIABLE chTimer AS COMPONENT-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE VARIABLE vDesData AS CHARACTER FORMAT "X(256)":U INITIAL "Data" 
      VIEW-AS TEXT 
     SIZE 41 BY .75 NO-UNDO.

DEFINE VARIABLE vDesStatus AS CHARACTER FORMAT "X(256)":U INITIAL "Status" 
      VIEW-AS TEXT 
     SIZE 41 BY .75 NO-UNDO.

DEFINE IMAGE IMAGE-1
     FILENAME "image/cntrlhry":U
     SIZE 7 BY 1.67.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fComm
     vDesStatus AT ROW 1.29 COL 11 COLON-ALIGNED NO-LABEL
     vDesData AT ROW 2.33 COL 11 COLON-ALIGNED NO-LABEL
     IMAGE-1 AT ROW 1.5 COL 3
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 53.2 BY 2.62
         FONT 1.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Window
   Allow: Basic,Browse,DB-Fields,Window,Query
   Other Settings: COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW C-Win ASSIGN
         HIDDEN             = YES
         TITLE              = "Data Collection Comm Manager"
         HEIGHT             = 2.5
         WIDTH              = 53.86
         MAX-HEIGHT         = 16
         MAX-WIDTH          = 80
         VIRTUAL-HEIGHT     = 16
         VIRTUAL-WIDTH      = 80
         RESIZE             = no
         SCROLL-BARS        = no
         STATUS-AREA        = no
         BGCOLOR            = ?
         FGCOLOR            = ?
         KEEP-FRAME-Z-ORDER = yes
         THREE-D            = yes
         MESSAGE-AREA       = no
         SENSITIVE          = yes.
ELSE {&WINDOW-NAME} = CURRENT-WINDOW.

&IF '{&WINDOW-SYSTEM}' NE 'TTY' &THEN
IF NOT C-Win:LOAD-ICON("image/cntrlhry":U) THEN
    MESSAGE "Unable to load icon: image\cntrlhry"
            VIEW-AS ALERT-BOX WARNING BUTTONS OK.
&ENDIF
/* END WINDOW DEFINITION                                                */
&ANALYZE-RESUME



/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW C-Win
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME fComm
                                                                        */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(C-Win)
THEN C-Win:HIDDEN = no.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME




/* **********************  Create OCX Containers  ********************** */

&ANALYZE-SUSPEND _CREATE-DYNAMIC

&IF "{&OPSYS}" = "WIN32":U AND "{&WINDOW-SYSTEM}" NE "TTY":U &THEN

CREATE CONTROL-FRAME Comm ASSIGN
       FRAME           = FRAME fComm:HANDLE
       ROW             = 1.25
       COLUMN          = 43
       HEIGHT          = 1.58
       WIDTH           = 5.43
       HIDDEN          = yes
       SENSITIVE       = yes.

CREATE CONTROL-FRAME Timer ASSIGN
       FRAME           = FRAME fComm:HANDLE
       ROW             = 1.5
       COLUMN          = 35
       HEIGHT          = 1.17
       WIDTH           = 4
       HIDDEN          = yes
       SENSITIVE       = yes.
      Comm:NAME = "Comm":U .
/* Comm OCXINFO:CREATE-CONTROL from: {648A5600-2C6E-101B-82B6-000000000014} type: MSComm */
      Timer:NAME = "Timer":U .
/* Timer OCXINFO:CREATE-CONTROL from: {F0B88A90-F5DA-11CF-B545-0020AF6ED35A} type: PSTimer */
      Timer:MOVE-AFTER(Comm).

&ENDIF

&ANALYZE-RESUME /* End of _CREATE-DYNAMIC */


/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME C-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL C-Win C-Win
ON END-ERROR OF C-Win /* Data Collection Comm Manager */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
   /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
   IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL C-Win C-Win
ON WINDOW-CLOSE OF C-Win /* Data Collection Comm Manager */
DO:
   /* This event will close the window and terminate the procedure.  */
   APPLY "CLOSE":U TO THIS-PROCEDURE.
   RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Comm
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Comm C-Win OCX.OnComm
PROCEDURE Comm.MSComm.OnComm .
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  None required for OCX.
  Notes:       
------------------------------------------------------------------------------*/
   ASSIGN vCodError = chComm:MSComm:commevent.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Timer
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Timer C-Win OCX.Tick
PROCEDURE Timer.PSTimer.Tick .
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  None required for OCX.
  Notes:       
------------------------------------------------------------------------------*/
   RUN ReadPortBuffer.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK C-Win 


/* ***************************  Main Block  *************************** */

/* Set CURRENT-WINDOW: this will parent dialog-boxes and frames.        */
ASSIGN CURRENT-WINDOW                = {&WINDOW-NAME} 
       THIS-PROCEDURE:CURRENT-WINDOW = {&WINDOW-NAME}.

/* The CLOSE event can be used from inside or outside the procedure to  */
/* terminate it.                                                        */
ON CLOSE OF THIS-PROCEDURE 
   RUN disable_UI.

/* Best default for GUI applications is...                              */
PAUSE 0 BEFORE-HIDE.

/* Now enable the interface and wait for the exit condition.            */
/* (NOTE: handle ERROR and END-KEY so cleanup code will always fire.    */

RUN enable_UI.
ASSIGN CURRENT-WINDOW:WINDOW-STATE = 2.

ASSIGN Comm = chComm:CONTROLS:ITEM(1).

RUN ImportSettings.

IF RETURN-VALUE <> "" THEN
   Return Return-Value.
MAIN-BLOCK:
DO ON ERROR   UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK
   ON END-KEY UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK:
  IF NOT THIS-PROCEDURE:PERSISTENT THEN
    WAIT-FOR CLOSE OF THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ClearData C-Win 
PROCEDURE ClearData :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
   ASSIGN vDesBufferReg = ''.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE CloseReader C-Win 
PROCEDURE CloseReader :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
   ASSIGN vDesStatus:SCREEN-VALUE IN FRAME {&FRAME-NAME} = 'Closing Connection...'.
   RUN DisconnectPort.
   APPLY 'close' TO THIS-PROCEDURE.  

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ConnectPort C-Win 
PROCEDURE ConnectPort :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
   ASSIGN vDesSettings = STRING(vNumBitsPerSecond) + ","
                       + SUBSTR(vDesParity, 1, 1) + ","
                       + STRING(vNumDataBits) + ","
                       + STRING(vNumStopBits).

   IF chComm:MSComm:PortOpen THEN
      ASSIGN chComm:MSComm:PortOpen = NO.

   ASSIGN chComm:MSComm:CommPort = vNumCommPort
          chComm:MSComm:SETTINGS = vDesSettings.

   ASSIGN chComm:MSComm:Handshaking = 0.

   IF NOT chComm:MSComm:PortOpen THEN
      ASSIGN chComm:MSComm:PortOpen = YES.

   IF NOT chComm:MSComm:PortOpen THEN DO:
      ASSIGN vDesStatus:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "Port COM:" + STRING(vNumCommPort,'9') + " NOT connected".

      DEFINE VARIABLE c-lbl-liter-cannot-open-port-com AS CHARACTER NO-UNDO.
      {utp/ut-liter.i "Cannot_Open_Port_COM" *}
      ASSIGN c-lbl-liter-cannot-open-port-com = TRIM(RETURN-VALUE).
      DEFINE VARIABLE c-lbl-liter-this-error-may-be-caused-by-a AS CHARACTER NO-UNDO.
      {utp/ut-liter.i "This_error_may_be_caused_by_a_configuration_error" *}
      ASSIGN c-lbl-liter-this-error-may-be-caused-by-a = TRIM(RETURN-VALUE).
      DEFINE VARIABLE c-lbl-liter-please-review-your-configurati AS CHARACTER NO-UNDO.
      {utp/ut-liter.i "Please_review_your_configuration_file_DCOMM.ini" *}
      ASSIGN c-lbl-liter-please-review-your-configurati = TRIM(RETURN-VALUE).
      DEFINE VARIABLE c-lbl-liter-and-try-again AS CHARACTER NO-UNDO.
      {utp/ut-liter.i "and_try_again" *}
      ASSIGN c-lbl-liter-and-try-again = TRIM(RETURN-VALUE).
      MESSAGE c-lbl-liter-cannot-open-port-com + ':' + STRING(vNumCommPort,'9') SKIP
              c-lbl-liter-this-error-may-be-caused-by-a SKIP
              c-lbl-liter-please-review-your-configurati + '  ' SKIP
              c-lbl-liter-and-try-again + '.' VIEW-AS ALERT-BOX ERROR.
      RETURN "NOK".
   End.
   ELSE DO:
    vDesStatus:SCREEN-VALUE IN FRAME {&FRAME-NAME} =
      'Port COM:' + STRING(vNumCommPort,'9') + ' is Now Open and Running'.
   END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Controltimer C-Win 
PROCEDURE Controltimer :
/*------------------------------------------------------------------------------
  Purpose: controlar propriedades do timer  
  Parameters:  l-ligado,i-intervalo
  Notes:       
------------------------------------------------------------------------------*/
   DEFINE INPUT PARAMETER l-ligado    AS LOGICAL NO-UNDO.
   DEFINE INPUT PARAMETER i-intervalo AS INTEGER NO-UNDO.

   IF l-ligado <> ? THEN
      ASSIGN chtimer:PSTimer:ENABLED = l-ligado.
      
   IF i-intervalo <> ? AND i-intervalo >= 0 THEN 
      ASSIGN chtimer:PSTimer:INTERVAL = i-intervalo.
      
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE control_load C-Win  _CONTROL-LOAD
PROCEDURE control_load :
/*------------------------------------------------------------------------------
  Purpose:     Load the OCXs    
  Parameters:  <none>
  Notes:       Here we load, initialize and make visible the 
               OCXs in the interface.                        
------------------------------------------------------------------------------*/

&IF "{&OPSYS}" = "WIN32":U AND "{&WINDOW-SYSTEM}" NE "TTY":U &THEN
DEFINE VARIABLE UIB_S    AS LOGICAL    NO-UNDO.
DEFINE VARIABLE OCXFile  AS CHARACTER  NO-UNDO.

OCXFile = SEARCH( "bcp/bcapi014.wrx":U ).
IF OCXFile = ? THEN
  OCXFile = SEARCH(SUBSTRING(THIS-PROCEDURE:FILE-NAME, 1,
                     R-INDEX(THIS-PROCEDURE:FILE-NAME, ".":U), "CHARACTER":U) + "wrx":U).

IF OCXFile <> ? THEN
DO:
  ASSIGN
    chComm = Comm:COM-HANDLE
    UIB_S = chComm:LoadControls( OCXFile, "Comm":U)
    chTimer = Timer:COM-HANDLE
    UIB_S = chTimer:LoadControls( OCXFile, "Timer":U)
  .
  RUN initialize-controls IN THIS-PROCEDURE NO-ERROR.
END.
ELSE MESSAGE "bcapi014.wrx":U SKIP(1)
             "The binary control file could not be found. The controls cannot be loaded."
             VIEW-AS ALERT-BOX TITLE "Controls Not Loaded".

&ENDIF

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE DefinefileIni C-Win 
PROCEDURE DefinefileIni :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
   DEFINE INPUT PARAMETER vdefini AS CHARACTER NO-UNDO.

   ASSIGN vdefinefileini = vdefini.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI C-Win  _DEFAULT-DISABLE
PROCEDURE disable_UI :
/*------------------------------------------------------------------------------
  Purpose:     DISABLE the User Interface
  Parameters:  <none>
  Notes:       Here we clean-up the user-interface by deleting
               dynamic widgets we have created and/or hide 
               frames.  This procedure is usually called when
               we are ready to "clean-up" after running.
------------------------------------------------------------------------------*/
  /* Delete the WINDOW we created */
  IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(C-Win)
  THEN DELETE WIDGET C-Win.
  IF THIS-PROCEDURE:PERSISTENT THEN DELETE PROCEDURE THIS-PROCEDURE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE DisconnectPort C-Win 
PROCEDURE DisconnectPort :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
   IF chComm:MSComm:PortOpen Then
      ASSIGN chComm:MSComm:PortOpen = NO.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI C-Win  _DEFAULT-ENABLE
PROCEDURE enable_UI :
/*------------------------------------------------------------------------------
  Purpose:     ENABLE the User Interface
  Parameters:  <none>
  Notes:       Here we display/view/enable the widgets in the
               user-interface.  In addition, OPEN all queries
               associated with each FRAME and BROWSE.
               These statements here are based on the "Other 
               Settings" section of the widget Property Sheets.
------------------------------------------------------------------------------*/
  RUN control_load.
  DISPLAY vDesStatus vDesData 
      WITH FRAME fComm IN WINDOW C-Win.
  ENABLE vDesStatus vDesData IMAGE-1 
      WITH FRAME fComm IN WINDOW C-Win.
  {&OPEN-BROWSERS-IN-QUERY-fComm}
  VIEW C-Win.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE GetData C-Win 
PROCEDURE GetData :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
   DEFINE OUTPUT PARAMETER pDesRecord  AS CHARACTER NO-UNDO.
   DEFINE OUTPUT PARAMETER pDesbuffer  AS CHARACTER NO-UNDO.

   ASSIGN PDesRecord = vDesBufferReg
          pDesbuffer = vDesBuffer.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ImportSettings C-Win 
PROCEDURE ImportSettings :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
   IF vdefinefileini = "" THEN 
      ASSIGN vdefinefileini = 'bcp/bcapi014.ini'. 

   ASSIGN vDesParameterFile = SEARCH(vdefinefileini).

   If SEARCH(vDesParameterFile) = ? THEN DO:
      DEFINE VARIABLE c-lbl-liter-parameter-file AS CHARACTER NO-UNDO.
      {utp/ut-liter.i "Parameter_File" *}
      ASSIGN c-lbl-liter-parameter-file = TRIM(RETURN-VALUE).
      DEFINE VARIABLE c-lbl-liter-not-found AS CHARACTER NO-UNDO.
      {utp/ut-liter.i "Not_Found" *}
      ASSIGN c-lbl-liter-not-found = TRIM(RETURN-VALUE).
      DEFINE VARIABLE c-lbl-liter-file-not-found AS CHARACTER NO-UNDO.
      {utp/ut-liter.i "File_not_Found" *}
      ASSIGN c-lbl-liter-file-not-found = TRIM(RETURN-VALUE).
      MESSAGE c-lbl-liter-parameter-file + ' ' + TRIM(vdefinefileini) + ' ' + c-lbl-liter-not-found
         VIEW-AS ALERT-BOX ERROR TITLE c-lbl-liter-file-not-found.
      RETURN "NOK".
   END.

   INPUT STREAM stParam FROM VALUE(vDesParameterFile).

   REPEAT:
      IMPORT STREAM stParam UNFORMATTED vDesLine.

      IF INDEX(vDesLine,'=') = 0 THEN NEXT.

      CASE ENTRY(1,vDesLine,'='):
         WHEN 'Comm_Port' THEN 
            ASSIGN  vNumCommPort = INTEGER(ENTRY(2,vDesLine,'=')).
         WHEN 'Bits_Per_Second' THEN 
            ASSIGN  vNumBitsPerSecond = INTEGER(ENTRY(2,vDesLine,'=')).
         WHEN 'Data_Bits' THEN 
            ASSIGN  vNumDataBits = INTEGER(ENTRY(2,vDesLine,'=')).
         WHEN 'Parity' THEN 
            ASSIGN  vDesParity = ENTRY(2,vDesLine,'=').
         WHEN 'Stop_Bits' THEN 
            ASSIGN  vNumStopBits = INTEGER(ENTRY(2,vDesLine,'=')).
         WHEN 'Flow_Control' THEN 
            ASSIGN  vDesFlowControl = ENTRY(2,vDesLine,'=').
         WHEN '' THEN.
      END CASE.
   END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ReadPortBuffer C-Win 
PROCEDURE ReadPortBuffer :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
   ASSIGN vDesData:SCREEN-VALUE IN FRAME {&FRAME-NAME} = 'Reading...'.

   IF NOT chComm:MSComm:PortOpen THEN DO:
      ASSIGN vDesStatus:SCREEN-VALUE IN FRAME {&FRAME-NAME} = 'Error Reading Data'.
      RETURN.
   END.

   ASSIGN vDesBuffer = chComm:MSComm:INPUT.

   IF vDesBuffer = ? or vDesBuffer = '' THEN DO:
      ASSIGN vDesData:SCREEN-VALUE IN FRAME {&FRAME-NAME} = 'No Data'.
      RETURN.
   END.

   ASSIGN vDesData:SCREEN-VALUE IN FRAME {&FRAME-NAME} = SUBSTRING(vDesBuffer,1,256).

   ASSIGN vDesBufferReg = IF LENGTH(vDesBufferReg) >= 5000 THEN
      SUBSTRING(vDesBufferReg,1000) + vDesBuffer ELSE vDesBufferReg + vDesBuffer.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ReturnErrorEvent C-Win 
PROCEDURE ReturnErrorEvent :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
   DEFINE OUTPUT PARAMETER cError AS INTEGER NO-UNDO.

   ASSIGN cError = vCodError.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE DefineParametersDirect C-Win 
PROCEDURE DefineParametersDirect :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
   DEFINE INPUT PARAMETER pvNumCommPort       AS INTEGER   NO-UNDO.
   DEFINE INPUT PARAMETER pvNumBitsPerSecond  AS INTEGER   NO-UNDO.
   DEFINE INPUT PARAMETER pvNumDataBits       AS INTEGER   NO-UNDO.
   DEFINE INPUT PARAMETER pvDesParity         AS CHARACTER NO-UNDO.
   DEFINE INPUT PARAMETER pvNumStopBits       AS INTEGER   NO-UNDO.
   DEFINE INPUT PARAMETER pvDesFlowControl    AS CHARACTER NO-UNDO.

   ASSIGN vNumCommPort       = pvNumCommPort       
          vNumBitsPerSecond  = pvNumBitsPerSecond  
          vNumDataBits       = pvNumDataBits       
          vDesParity         = pvDesParity         
          vNumStopBits       = pvNumStopBits       
          vDesFlowControl    = pvDesFlowControl.    

END PROCEDURE.


/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

PROCEDURE Connect EXTERNAL "Dcportserial.dll" CDECL PERSISTENT:
   DEFINE INPUT  PARAMETER portaSerial AS CHARACTER NO-UNDO.
   DEFINE RETURN PARAMETER hInstance   AS LONG      NO-UNDO.
END.

PROCEDURE ReadString EXTERNAL "Dcportserial.dll" CDECL PERSISTENT:
   DEFINE RETURN PARAMETER peso AS MEMPTR  NO-UNDO.
END.

PROCEDURE Disconnect EXTERNAL "Dcportserial.dll" CDECL PERSISTENT:
   DEFINE RETURN PARAMETER hInstance AS LONG.
END.

