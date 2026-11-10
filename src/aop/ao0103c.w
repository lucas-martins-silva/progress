&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          mgind            PROGRESS
*/
&Scoped-define WINDOW-NAME wWindow

/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE tt-mab-eqpto-sub-sist NO-UNDO LIKE mab-eqpto-sub-sist.


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS wWindow 
/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i AO0103C 2.00.00.000}  /*** 010000 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i ao0103c MAO}
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
&GLOBAL-DEFINE Program           AO0103C
&GLOBAL-DEFINE Version           2.00.00.000

&GLOBAL-DEFINE Folder            NO
&GLOBAL-DEFINE InitialPage       1


&GLOBAL-DEFINE WindowType     Detail

&GLOBAL-DEFINE page0Widgets   tt-cod-tip-mater fi-cod-tip-mater tt-des-tip-mater ~
                              fi-des-tip-mater btOk btCancel btHelp2


/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */
DEFINE VARIABLE hDBOParent    AS HANDLE     NO-UNDO.
DEFINE VARIABLE hDBOEnsaios   AS HANDLE     NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fpage0

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS tt-cod-tip-mater tt-des-tip-mater ~
fi-cod-tip-mater fi-des-tip-mater btOK btCancel btHelp2 RECT-5 RECT-6 ~
rtToolBar 
&Scoped-Define DISPLAYED-OBJECTS tt-cod-tip-mater tt-des-tip-mater ~
fi-cod-tip-mater fi-des-tip-mater 

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

DEFINE VARIABLE fi-cod-tip-mater AS CHARACTER FORMAT "x(8)" 
     LABEL "Tipo Material":R16 
     VIEW-AS FILL-IN 
     SIZE 8 BY .88.

DEFINE VARIABLE fi-des-tip-mater AS CHARACTER FORMAT "x(30)" 
     VIEW-AS FILL-IN 
     SIZE 30 BY .88.

DEFINE VARIABLE tt-cod-tip-mater AS CHARACTER FORMAT "x(8)" 
     LABEL "Tipo Material":R16 
     VIEW-AS FILL-IN 
     SIZE 8 BY .88.

DEFINE VARIABLE tt-des-tip-mater AS CHARACTER FORMAT "x(30)" 
     VIEW-AS FILL-IN 
     SIZE 30 BY .88.

DEFINE RECTANGLE RECT-5
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 59 BY 2.25.

DEFINE RECTANGLE RECT-6
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 59 BY 2.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE  
     SIZE 60 BY 1.42
     BGCOLOR 7 .


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fpage0
     tt-cod-tip-mater AT ROW 1.92 COL 12 COLON-ALIGNED
     tt-des-tip-mater AT ROW 1.92 COL 20.29 COLON-ALIGNED NO-LABEL
     fi-cod-tip-mater AT ROW 4.5 COL 12 COLON-ALIGNED
     fi-des-tip-mater AT ROW 4.5 COL 20.29 COLON-ALIGNED NO-LABEL
     btOK AT ROW 6.42 COL 2
     btCancel AT ROW 6.42 COL 13
     btHelp2 AT ROW 6.42 COL 50.14
     RECT-5 AT ROW 1.25 COL 2
     RECT-6 AT ROW 4 COL 2
     rtToolBar AT ROW 6.21 COL 1
     "Origem" VIEW-AS TEXT
          SIZE 8 BY .75 AT ROW 1 COL 3
     "Destino" VIEW-AS TEXT
          SIZE 8 BY .54 AT ROW 3.75 COL 3
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 60.86 BY 6.88
         FONT 1.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Window
   Allow: Basic,Browse,DB-Fields,Window,Query
   Add Fields to: Neither
   Temp-Tables and Buffers:
      TABLE: tt-mab-eqpto-sub-sist T "?" NO-UNDO mgind mab-eqpto-sub-sist
   END-TABLES.
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW wWindow ASSIGN
         HIDDEN             = YES
         TITLE              = ""
         HEIGHT             = 6.71
         WIDTH              = 60
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB wWindow 
/* ************************* Included-Libraries *********************** */

{utp/ut-glob.i}
{btb/btb008za.i0}
{window/window.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW wWindow
  NOT-VISIBLE,,RUN-PERSISTENT                                           */
/* SETTINGS FOR FRAME fpage0
   FRAME-NAME                                                           */
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
 /*** Liga a ampulheta ***/
   if  session:set-wait-state('general':U) then do:
   end /* if */.

   RUN emptyRowErrors    IN hDBOEnsaios.
   RUN copiaEnsaiosMatl  IN hDBOEnsaios (input INPUT frame {&frame-name} tt-cod-tip-mater,
                                         input INPUT frame {&frame-name} fi-cod-tip-mater).
   
   /*** Desliga a ampulheta ***/
   if  session:set-wait-state('':U) then do:
   end /* if */.

   if return-value = "OK" then do:
       /** Tipo de Material **/
       if valid-handle(hDBOParent) then
           run destroy IN hDBOParent.
       /**** Ensaios ***/
       if valid-handle(hDBOEnsaios) then
           run destroy IN hDBOEnsaios.
      apply "close" to this-procedure. 
   end.
   else do:
      RUN getRowErrors IN hDBOEnsaios (OUTPUT TABLE RowErrors).
      {method/showmessage.i1}
      {method/showmessage.i2}
   end.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fi-cod-tip-mater
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-cod-tip-mater wWindow
ON LEAVE OF fi-cod-tip-mater IN FRAME fpage0 /* Tipo Material */
DO:
    {method\referenceFields.i
          &HandleDBOLeave="hDBOParent"
          &KeyValue1="fi-cod-tip-mater:screen-value in frame fPage0"
          &FieldName1="des-tip-mater"
          &FieldScreen1="fi-des-tip-mater"
          &Frame1="fPage0"}  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-cod-tip-mater wWindow
ON MOUSE-SELECT-DBLCLICK OF fi-cod-tip-mater IN FRAME fpage0 /* Tipo Material */
OR "F5":U OF fi-cod-tip-mater IN FRAME fPage0 DO:
    {method/zoomfields.i 
       &ProgramZoom="frzoom~\z01fr026.w"
       &FieldZoom1="cod-tip-mater"
       &FieldScreen1="fi-cod-tip-mater"
       &Frame1="fPage0"
       &FieldZoom2="des-tip-mater"
       &FieldScreen2="fi-des-tip-mater"
       &Frame2="fPage0"
       &EnableImplant="no"}    
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tt-cod-tip-mater
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-cod-tip-mater wWindow
ON LEAVE OF tt-cod-tip-mater IN FRAME fpage0 /* Tipo Material */
DO:
  {method\referenceFields.i
        &HandleDBOLeave="hDBOParent"
        &KeyValue1="tt-cod-tip-mater:screen-value in frame fPage0"
        &FieldName1="des-tip-mater"
        &FieldScreen1="tt-des-tip-mater"
        &Frame1="fPage0"}  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-cod-tip-mater wWindow
ON MOUSE-SELECT-DBLCLICK OF tt-cod-tip-mater IN FRAME fpage0 /* Tipo Material */
OR "F5":U OF tt-cod-tip-mater IN FRAME fPage0 DO:
        {method/zoomfields.i 
           &ProgramZoom="frzoom~\z01fr026.w"
           &FieldZoom1="cod-tip-mater"
           &FieldScreen1="tt-cod-tip-mater"
           &Frame1="fPage0"
           &FieldZoom2="des-tip-mater"
           &FieldScreen2="tt-des-tip-mater"
           &Frame2="fPage0"
           &EnableImplant="no"}    
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wWindow 


if tt-cod-tip-mater:load-mouse-pointer  ("image/lupa.cur") in frame {&frame-name} then.
if fi-cod-tip-mater:load-mouse-pointer ("image/lupa.cur") in frame {&frame-name} then.

/*--- L¢gica para inicializa‡Æo do programam ---*/
{window/mainblock.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterInitializeInterface wWindow 
PROCEDURE afterInitializeInterface :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    /*:T--- Verifica se o DBO j  est  inicializado ---*/
   

    assign tt-des-tip-mater:SENSITIVE IN FRAME {&FRAME-NAME} = NO
           fi-des-tip-mater:SENSITIVE IN FRAME {&FRAME-NAME} = NO.

 
RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE beforeInitializeInterface wWindow 
PROCEDURE beforeInitializeInterface :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
/**** Tipo de Material ***/
  IF NOT VALID-HANDLE(hDBOParent) OR
       hDBOParent:TYPE <> "PROCEDURE":U OR
       hDBOParent:FILE-NAME <> "frbo/bofr026.p":U THEN DO:
        RUN frbo/bofr026.p PERSISTENT SET  hDBOParent.
    END.
    RUN openQueryStatic IN hDBOParent (INPUT "Main":U) NO-ERROR.
    /**** Ensaios*****/
    IF NOT VALID-HANDLE(hDBOEnsaios) OR
       hDBOEnsaios:TYPE <> "PROCEDURE":U OR
       hDBOEnsaios:FILE-NAME <> "frbo/bofr104.p":U THEN DO:
        RUN frbo/bofr104.p PERSISTENT SET  hDBOEnsaios.
    END.
    RUN openQueryStatic IN hDBOEnsaios (INPUT "Main":U) NO-ERROR.
   
RETURN "ok":u.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setaMaterial wWindow 
PROCEDURE setaMaterial :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF INPUT PARAM pRowid AS ROWID NO-UNDO.

RUN repositionRecord IN hDBOParent (INPUT pRowid).
RUN getCharField     IN hDBOParent (input "cod-tip-mater":U, output tt-cod-tip-mater).
RUN getCharField     IN hDBOParent (input "des-tip-mater":U, output tt-des-tip-mater).
DISP tt-cod-tip-mater
     tt-des-tip-mater   WITH FRAME fpage0.

RETURN "Ok":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

