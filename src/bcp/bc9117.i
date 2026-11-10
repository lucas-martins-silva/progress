&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Include 
/*--------------------------------------------------------------------------
    File        : 
    Purpose     :

    Syntax      :

    Description :

    Author(s)   :
    Created     :
    Notes       :
  ------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.             */
/*----------------------------------------------------------------------*/

/* portions (c) Jurjen Dijkstra 1997-1998 */

/* ***************************  Definitions  ************************** */

&IF DEFINED(WINDOWS_I)=0 &THEN
&GLOBAL-DEFINE WINDOWS_I
  

&IF "{&OPSYS}":U="WIN32":U &THEN

   &GLOBAL ListGrid 1
   &GLOBAL ListTrack 8
   &GLOBAL ListDragHeader 16
   &GLOBAL ListSelectRow 32
   &GLOBAL ListFlatScroll 256
   &GLOBAL DotRListStyle 1 + 16 + 32
   
   /* 32-bit definitions, Progress 8.2+ */

   /* data types */
   &Glob HWND long
   &Glob BOOL long
   &Glob HINSTANCE long
   &Glob INT long
   &GLOB INTSIZE 4

   /* libraries */
   &GLOB USER   "user32"
   &GLOB KERNEL "kernel32"
   &GLOB SHELL  "shell32"
   &GLOB MAPI   "mapi32"
   &GLOB GDI    "gdi32"
   &GLOB A A

&ELSE
   /* 16-bit definitions, Progress 7 to 8.1 */

   /* data types */
   &Glob HWND short
   &Glob BOOL short
   &Glob HINSTANCE short
   &Glob INT short
   &GLOB INTSIZE 2

   /* libraries */
   &GLOB USER   "user.exe"
   &GLOB KERNEL "kernel.exe"
   &GLOB SHELL  "shell.dll"
   &GLOB MAPI   "mapi.dll"
   &GLOB GDI    "gdi.exe"
   &GLOB A

&ENDIF

/* messages */
&Glob WM_HSCROLL 276
&Glob WM_VSCROLL 277
&Glob WM_RBUTTONDOWN 516
&Glob WM_RBUTTONUP 517
&GLOB WM_USER 1024

/* mouse buttons */
&Glob MK_RBUTTON 2

/* scrollbars */
&Glob SB_HORZ 0
&Glob SB_VERT 1
&Glob SB_BOTH 3
&Glob SB_THUMBPOSITION 4

/* editors */
&GLOB EM_SETPASSWORDCHAR {&WM_USER} + 28

/* some window styles */
&GLOB GWL_STYLE -16
&GLOB WS_MAXIMIZEBOX 65536
&GLOB WS_MINIMIZEBOX 131072
&GLOB WS_THICKFRAME  262144
&GLOB WS_CAPTION 12582912
&GLOB WS_BORDER 8388608
&GLOB HDS_BUTTONS 2
&GLOB LVM_FIRST 4096
&GLOB LVM_GETHEADER {&LVM_FIRST} + 31

/* some extended window styles */
&GLOB GWL_EXSTYLE -20
&GLOB WS_EX_CONTEXTHELP 1024
&GLOB WS_EX_PALETTEWINDOW 392

/* system commands/menu */
&GLOB SC_SIZE      61440  
&GLOB SC_MINIMIZE  61472
&GLOB SC_MAXIMIZE  61488  
&GLOB MF_BYCOMMAND 0

/* placement order (Z-order) */
&GLOB HWND_TOPMOST -1
&GLOB HWND_NOTOPMOST -2
 
/* window-positioning flags */
&GLOB SWP_NOSIZE 1
&GLOB SWP_NOMOVE 2
&GLOB SWP_NOZORDER 4
&GLOB SWP_NOACTIVATE 16 
&GLOB SWP_FRAMECHANGED 32
&GLOB SWP_SHOWWINDOW 64
&GLOB SWP_DRAWFRAME 32
&GLOB SWP_FLAGS {&SWP_NOZORDER} + {&SWP_NOSIZE} + {&SWP_NOMOVE} + {&SWP_DRAWFRAME}

&ENDIF  /* &IF DEFINED(WINDOWS_I)=0 */

DEF VAR iListViewStyle AS INT NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD BlankField Include 
FUNCTION BlankField RETURNS LOGICAL
  ( INPUT ip_hObject AS HANDLE)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD GetWindowsUser Include 
FUNCTION GetWindowsUser RETURNS CHARACTER
( /* */ ) FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD SetListViewStyle Include 
FUNCTION SetListViewStyle RETURNS LOGICAL
  (INPUT ip_iHwnd AS INT,
   INPUT ip_iStyle AS INT)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Include
   Allow: 
   Frames: 0
   Add Fields to: Neither
   Other Settings: INCLUDE-ONLY
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW Include ASSIGN
         HEIGHT             = 2
         WIDTH              = 40.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME
 



&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Include 


/* ***************************  Main Block  *************************** */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE WinAPI Include 
PROCEDURE WinAPI :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

END PROCEDURE.

PROCEDURE SendMessageA EXTERNAL {&USER}:
    DEFINE INPUT PARAMETER hwnd   AS {&HWND}.
    DEFINE INPUT PARAMETER umsg   AS {&INT}.
    DEFINE INPUT PARAMETER wparam AS {&INT}.
    DEFINE INPUT PARAMETER lparam AS LONG.
    DEFINE RETURN PARAMETER iResult AS LONG.    
END.

PROCEDURE GetUserName{&A} external "advapi32.dll" :
   define input-output parameter lpBuffer as char.
   define input-output parameter nSize as long.
END PROCEDURE.

PROCEDURE GetWindowLong{&A} EXTERNAL {&USER}:
    DEFINE INPUT PARAMETER hwnd   AS {&HWND}.
    DEFINE INPUT PARAMETER nIndex AS LONG.
    DEFINE RETURN PARAMETER nResult AS LONG.
END.

PROCEDURE SetWindowLong{&A} EXTERNAL {&USER}:
    DEFINE INPUT PARAMETER hwnd   AS {&HWND}.
    DEFINE INPUT PARAMETER nIndex AS LONG.
    DEFINE INPUT PARAMETER nNew   AS LONG.
    DEFINE RETURN PARAMETER nResult AS LONG.
END.

PROCEDURE SetWindowPos EXTERNAL {&USER}:
    DEFINE INPUT PARAMETER hwnd   AS {&HWND}.
    DEFINE INPUT PARAMETER nIndex AS LONG.
    DEFINE INPUT PARAMETER x AS LONG.
    DEFINE INPUT PARAMETER y AS LONG.
    DEFINE INPUT PARAMETER cx AS LONG.
    DEFINE INPUT PARAMETER cy AS LONG.
    DEFINE INPUT PARAMETER Flags AS LONG.
    DEFINE RETURN PARAMETER nResult AS LONG.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION BlankField Include 
FUNCTION BlankField RETURNS LOGICAL
  ( INPUT ip_hObject AS HANDLE) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  DEF VAR iResult AS INT NO-UNDO.
  
  RUN SendMessageA IN THIS-PROCEDURE
      (ip_hObject:hWnd,{&EM_SETPASSWORDCHAR},ASC("*":U),0,OUTPUT iResult).

  RETURN TRUE.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION GetWindowsUser Include 
FUNCTION GetWindowsUser RETURNS CHARACTER
( /* */ ):
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

 DEF VAR cUser AS CHAR NO-UNDO.
 
 DEF VAR iSize AS INT INIT 128 NO-UNDO.
 
 ASSIGN cUser = FILL(" ",iSize).
 
 RUN GetUserName{&A} IN THIS-PROCEDURE
     (INPUT-OUTPUT cUser,
      INPUT-OUTPUT iSize).

 RETURN cUser.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION SetListViewStyle Include 
FUNCTION SetListViewStyle RETURNS LOGICAL
  (INPUT ip_iHwnd AS INT,
   INPUT ip_iStyle AS INT) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  DEF VAR iResult AS INT NO-UNDO.

  RUN SendMessageA (ip_ihWnd,4150,0,ip_iStyle,OUTPUT iResult) NO-ERROR.

  RETURN ERROR-STATUS:ERROR.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


