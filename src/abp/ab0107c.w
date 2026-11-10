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
{include/i-prgvrs.i AB0107C 2.00.00.000}  /*** 010000 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i ab0107c MAB}
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
&GLOBAL-DEFINE Program        AB0107C
&GLOBAL-DEFINE Version        2.00.00.000

&GLOBAL-DEFINE WindowType     Detail

&GLOBAL-DEFINE page0Widgets   c-grupo-origem c-grupo-destino c-desc-origem ~
                              c-desc-destino btOk btCancel btHelp2


DEFINE NEW GLOBAL SHARED VARIABLE gr-grupo AS ROWID NO-UNDO.
/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */
DEFINE VARIABLE hDBOGrupoSub AS HANDLE NO-UNDO.
DEFINE VARIABLE hDBOgrupo    AS HANDLE NO-UNDO.


DEFINE VARIABLE r-rowid     AS ROWID  NO-UNDO.


DEFINE VARIABLE wh-pesquisa AS HANDLE NO-UNDO.

DEFINE NEW GLOBAL SHARED VARIABLE adm-broker-hdl AS HANDLE NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fpage0

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS c-grupo-origem c-grupo-destino ~
c-desc-destino lSobrepor btOK btCancel btHelp2 RECT-5 RECT-6 rtToolBar 
&Scoped-Define DISPLAYED-OBJECTS c-desc-origem c-grupo-origem ~
c-grupo-destino c-desc-destino lSobrepor 

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

DEFINE VARIABLE c-desc-destino AS CHARACTER FORMAT "X(30)":U 
     VIEW-AS FILL-IN 
     SIZE 44.14 BY .88 NO-UNDO.

DEFINE VARIABLE c-desc-origem AS CHARACTER FORMAT "X(30)":U 
     VIEW-AS FILL-IN 
     SIZE 44.14 BY .88 NO-UNDO.

DEFINE VARIABLE c-grupo-destino AS CHARACTER FORMAT "X(8)" 
     LABEL "Grupo" 
     VIEW-AS FILL-IN 
     SIZE 11.86 BY .88 NO-UNDO.

DEFINE VARIABLE c-grupo-origem AS CHARACTER FORMAT "X(8)" 
     LABEL "Grupo" 
     VIEW-AS FILL-IN 
     SIZE 11.86 BY .88 NO-UNDO.

DEFINE RECTANGLE RECT-5
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 71 BY 2.25.

DEFINE RECTANGLE RECT-6
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 71 BY 2.75.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE  
     SIZE 72 BY 1.42
     BGCOLOR 7 .

DEFINE VARIABLE lSobrepor AS LOGICAL INITIAL no 
     LABEL "Sobrepor se j  existir" 
     VIEW-AS TOGGLE-BOX
     SIZE 33 BY .83 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fpage0
     c-desc-origem AT ROW 2 COL 24.43 COLON-ALIGNED NO-LABEL
     c-grupo-origem AT ROW 2.04 COL 12 COLON-ALIGNED HELP
          "C¢digo do grupo"
     c-grupo-destino AT ROW 4.42 COL 12.14 COLON-ALIGNED HELP
          "C¢digo do grupo"
     c-desc-destino AT ROW 4.42 COL 24.57 COLON-ALIGNED NO-LABEL
     lSobrepor AT ROW 5.46 COL 14
     btOK AT ROW 7.21 COL 2
     btCancel AT ROW 7.21 COL 13
     btHelp2 AT ROW 7.21 COL 61
     RECT-5 AT ROW 1.25 COL 2
     RECT-6 AT ROW 4 COL 2
     rtToolBar AT ROW 7 COL 1
     "Origem" VIEW-AS TEXT
          SIZE 8 BY .75 AT ROW 1 COL 3
     "Destino" VIEW-AS TEXT
          SIZE 8 BY .54 AT ROW 3.75 COL 3
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 74.14 BY 7.46
         FONT 1.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Window
   Allow: Basic,Browse,DB-Fields,Window,Query
   Add Fields to: Neither
   Other Settings: COMPILE
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
         HEIGHT             = 7.54
         WIDTH              = 73.72
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
/* SETTINGS FOR FILL-IN c-desc-origem IN FRAME fpage0
   NO-ENABLE                                                            */
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

   RUN emptyRowErrors    IN hDBOGrupoSub.
   RUN copiaGrupoSub IN hDBOGrupoSub (input INPUT frame {&frame-name} c-grupo-origem,
                                        input INPUT frame {&frame-name} c-grupo-destino,
                                        INPUT INPUT FRAME {&frame-name} lSobrepor).
   
   /*** Desliga a ampulheta ***/
   if  session:set-wait-state('':U) then do:
   end /* if */.

   if return-value = "OK" then do:
      assign gr-grupo  = r-Rowid.
      apply "close" to this-procedure. 
   end.
   else do:
      RUN getRowErrors IN hDBOGrupoSub (OUTPUT TABLE RowErrors).
      {method/showmessage.i1}
      {method/showmessage.i2}
   end.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME c-grupo-destino
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-grupo-destino wWindow
ON F5 OF c-grupo-destino IN FRAME fpage0 /* grupo */
DO:
   
  {method/zoomfields.i 
      &ProgramZoom="frzoom/z01fr011.w"
      &FieldZoom1="cod-grp-eqpto"
      &FieldScreen1="c-grupo-destino"
      &Frame1="fPage0"
      &FieldZoom2="des-grp-eqpto"
      &FieldScreen2="c-desc-destino"
      &Frame2="fPage0"
      &EnableImplant="yes"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-grupo-destino wWindow
ON LEAVE OF c-grupo-destino IN FRAME fpage0 /* grupo */
DO:
      {method/ReferenceFields.i
              &HandleDBOLeave="hDBOgrupo"
              &KeyValue1="input frame fPage0 c-grupo-destino"
              &FieldName1="des-grp-eqpto"
              &FieldScreen1="c-desc-destino"
              &Frame1="{&frame-name}"}

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-grupo-destino wWindow
ON MOUSE-SELECT-DBLCLICK OF c-grupo-destino IN FRAME fpage0 /* grupo */
DO:
   apply 'F5' to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME c-grupo-origem
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-grupo-origem wWindow
ON F5 OF c-grupo-origem IN FRAME fpage0 /* grupo */
DO:
  {method/zoomfields.i 
      &ProgramZoom="frzoom/z01fr011.w"
      &FieldZoom1="cod-grp-eqpto"
      &FieldScreen1="c-grupo-origem"
      &Frame1="fPage0"
      &FieldZoom2="des-grp-eqpto"
      &FieldScreen2="c-desc-origem"
      &Frame2="fPage0"
      &EnableImplant="yes"}
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-grupo-origem wWindow
ON LEAVE OF c-grupo-origem IN FRAME fpage0 /* grupo */
DO:
{method/referencefields.i 
          &HandleDBOLeave="hDBOgrupo"
          &KeyValue1="input frame fPage0 c-grupo-origem"
          &FieldName1="des-grp-eqpto"
          &FieldScreen1="c-desc-origem"
          &Frame1="{&frame-name}"}
          
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-grupo-origem wWindow
ON MOUSE-SELECT-DBLCLICK OF c-grupo-origem IN FRAME fpage0 /* grupo */
DO:
   apply 'F5' to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wWindow 


if c-grupo-origem:load-mouse-pointer  ("image/lupa.cur") in frame {&frame-name} then.
if c-grupo-destino:load-mouse-pointer ("image/lupa.cur") in frame {&frame-name} then.

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

    IF NOT VALID-HANDLE(hDBOgrupo) THEN DO:
        RUN  frbo/bofr011.p PERSISTENT SET  hDBOgrupo.
    END.
    
    RUN openQueryStatic IN hDBOgrupo (INPUT "Main":U) NO-ERROR.

    IF NOT VALID-HANDLE(hDBOGrupoSub) THEN DO:
        RUN  frbo/bofr008.p PERSISTENT SET  hDBOGrupoSub.
    END.
    
    RUN openQueryStatic IN hDBOGrupoSub (INPUT "Main":U) NO-ERROR.


    if  gr-grupo <> ? then do:
      RUN repositionRecord IN hDBOgrupo (INPUT gr-grupo).
      RUN getCharField     IN hDBOgrupo(input "cod-grp-eqpto", output c-grupo-origem).
      RUN getCharField     IN hDBOgrupo(input "des-grp-eqpto":U, output c-desc-origem).
      assign c-grupo-origem:screen-value in frame {&frame-Name} = c-grupo-origem
             c-desc-origem:screen-value in frame {&frame-Name} = c-desc-origem.
          
    end.
    else assign c-grupo-origem  = ""
                c-desc-origem    = ""
                c-grupo-destino = ""
                c-desc-destino   = "" .
    {utp/ut-liter.i "Sobrepor se j  existir"}
    assign lSobrepor:label in frame fPage0     = trim(return-value)
           lSobrepor:SENSITIVE in frame fPage0 = YES
           c-desc-origem:SENSITIVE IN FRAME {&FRAME-NAME} = NO
           c-desc-destino:SENSITIVE IN FRAME {&FRAME-NAME} = NO.

 
RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setagrupo wWindow 
PROCEDURE setagrupo :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEF INPUT PARAM rRowid AS ROWID NO-UNDO.
    
    FOR FIRST mab-grp-eqpto WHERE ROWID(mab-grp-eqpto) = rRowid NO-LOCK:
        ASSIGN c-grupo-origem  = mab-grp-eqpto.cod-grp-eqpto
               c-desc-origem   = mab-grp-eqpto.des-grp-eqpto.
        DISP c-grupo-origem
             c-desc-origem
            WITH FRAME fPage0.
    END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

