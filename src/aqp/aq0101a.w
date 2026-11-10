&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME wWindow
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS wWindow 
/*:T*******************************************************************************
** Copyright TOTVS S.A. (2009)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da TOTVS, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i AQ0101A 2.00.00.010 } /*** 010010 ***/

/* Chamada a include do gerenciador de licenáas. Necessario alterar os parametros */
/*                                                                                */
/* <programa>:  Informar qual o nome do programa.                                 */
/* <m¢dulo>:  Informar qual o m¢dulo a qual o programa pertence.                  */

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i AQ0101A MAQ}
&ENDIF

CREATE WIDGET-POOL.

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program        AQ0101A
&GLOBAL-DEFINE Version        2.00.00.010

&GLOBAL-DEFINE WindowType     Master/Detail

&GLOBAL-DEFINE Folder         NO
&GLOBAL-DEFINE InitialPage    1
&GLOBAL-DEFINE FolderLabels   

&GLOBAL-DEFINE page0Widgets   btOK btCancel btHelp2
&GLOBAL-DEFINE page1Widgets

/* Parameters Definitions ---                                           */
DEFINE INPUT-OUTPUT PARAMETER pc-cod-period  LIKE param-aquis-rural.cod-period  NO-UNDO.
DEFINE INPUT-OUTPUT PARAMETER pcod-livre-2   LIKE param-aquis-rural.cod-livre-2 NO-UNDO.

/* Local Variable Definitions ---                                       */
{utp/ut-glob.i}

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
     LABEL "Cancelar" 
     SIZE 10 BY 1.

DEFINE BUTTON btHelp2 
     LABEL "Ajuda" 
     SIZE 10 BY 1.

DEFINE BUTTON btOK 
     LABEL "OK" 
     SIZE 10 BY 1.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 90 BY 1.42
     BGCOLOR 7 .

DEFINE VARIABLE c-mot-alteracao AS CHARACTER 
     VIEW-AS EDITOR MAX-CHARS 472 SCROLLBAR-VERTICAL
     SIZE 76 BY 5.5 TOOLTIP "Informe o motivo da alteraá∆o do per°odo" NO-UNDO.

DEFINE VARIABLE c-cod-period AS CHARACTER FORMAT "99/9999":U 
     LABEL "Èltimo Per°odo Fechado" 
     VIEW-AS FILL-IN 
     SIZE 13.57 BY .88 NO-UNDO.

DEFINE VARIABLE c-cod-usuario AS CHARACTER FORMAT "X(12)":U 
     LABEL "Usu†rio" 
     VIEW-AS FILL-IN 
     SIZE 13.57 BY .88 NO-UNDO.

DEFINE VARIABLE c-des-usuar AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 40 BY .88 NO-UNDO.

DEFINE VARIABLE da-data-hora AS DATETIME FORMAT "99/99/9999 HH:MM":U 
     LABEL "Data / Hora" 
     VIEW-AS FILL-IN 
     SIZE 13.57 BY .88 NO-UNDO.

DEFINE RECTANGLE RECT-25
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 79 BY 6.5.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fpage0
     btOK AT ROW 14.13 COL 2
     btCancel AT ROW 14.13 COL 13
     btHelp2 AT ROW 14.13 COL 80
     rtToolBar AT ROW 13.92 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 90 BY 14.75
         FONT 1 WIDGET-ID 100.

DEFINE FRAME fPage1
     da-data-hora AT ROW 2.25 COL 22.43 COLON-ALIGNED WIDGET-ID 2
     c-cod-usuario AT ROW 3.25 COL 22.43 COLON-ALIGNED WIDGET-ID 4
     c-des-usuar AT ROW 3.25 COL 36.14 COLON-ALIGNED NO-LABEL WIDGET-ID 6
     c-cod-period AT ROW 4.25 COL 22.43 COLON-ALIGNED WIDGET-ID 8
     c-mot-alteracao AT ROW 6.5 COL 5 NO-LABEL WIDGET-ID 12
     "Motivo Alteraá∆o" VIEW-AS TEXT
          SIZE 12 BY .54 AT ROW 5.46 COL 6 WIDGET-ID 14
     RECT-25 AT ROW 5.75 COL 3.43 WIDGET-ID 10
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.57 ROW 1.58
         SIZE 84.43 BY 11.83
         FONT 1 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Window
   Allow: Basic,Browse,DB-Fields,Window,Query
   Add Fields to: Neither
   Other Settings: COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW wWindow ASSIGN
         HIDDEN             = YES
         TITLE              = ""
         HEIGHT             = 14.75
         WIDTH              = 90
         MAX-HEIGHT         = 17
         MAX-WIDTH          = 90
         VIRTUAL-HEIGHT     = 17
         VIRTUAL-WIDTH      = 90
         RESIZE             = no
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
/* SETTINGS FOR FILL-IN c-cod-usuario IN FRAME fPage1
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-des-usuar IN FRAME fPage1
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN da-data-hora IN FRAME fPage1
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
    
    RUN piVerificaDados IN THIS-PROCEDURE.
    
    IF RETURN-VALUE = "OK":U THEN DO:

        RUN piGravaDados IN THIS-PROCEDURE.
        APPLY "CLOSE":U TO THIS-PROCEDURE.

    END.

    


    
    
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage1
&Scoped-define SELF-NAME c-cod-usuario
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-cod-usuario wWindow
ON LEAVE OF c-cod-usuario IN FRAME fPage1 /* Usu†rio */
DO:
   {include/leave.i &tabela=usuar_mestre
                    &atributo-ref=nom_usuario
                    &variavel-ref=c-des-usuar
                    &where="usuar_mestre.cod_usuario = input frame fPage1 c-cod-usuario"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fpage0
&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wWindow 


/*:T--- L¢gica para inicializaá∆o do programam ---*/
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

DO WITH FRAME fPage1:

    ASSIGN da-data-hora:SCREEN-VALUE  = SUBSTRING(STRING((DATETIME(TODAY, MTIME))),1,16)
           c-cod-usuario:SCREEN-VALUE = c-seg-usuario
           
           c-cod-period:SCREEN-VALUE  = pc-cod-period
           c-mot-alteracao:SCREEN-VALUE = TRIM(SUBSTRING(pcod-livre-2,29,472))

           c-cod-period:SENSITIVE     = YES
           c-mot-alteracao:SENSITIVE  = YES. 

    APPLY "LEAVE" TO c-cod-usuario.

END.


RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piGravaDados wWindow 
PROCEDURE piGravaDados :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    ASSIGN pc-cod-period = INPUT FRAME fPage1 c-cod-period
           OVERLAY(pcod-livre-2,1,16)   = INPUT FRAME fPage1 da-data-hora
           OVERLAY(pcod-livre-2,17,28)  = INPUT FRAME fPage1 c-cod-usuario
           OVERLAY(pcod-livre-2,29,472) = INPUT FRAME fPage1 c-mot-alteracao.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piVerificaDados wWindow 
PROCEDURE piVerificaDados :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    
    IF pc-cod-period <> "" THEN DO:
        IF (INT(SUBSTRING(INPUT FRAME fPage1 c-cod-period,1,2)) > INT(MONTH(TODAY)) AND
            INT(SUBSTRING(INPUT FRAME fPage1 c-cod-period,3,4)) >= INT(YEAR(TODAY))) 
           OR 
            INT(SUBSTRING(INPUT FRAME fPage1 c-cod-period,3,4)) > INT(YEAR(TODAY))
           THEN DO:
        
           {utp/ut-liter.i "Per°odo_n∆o_pode_ser_maior_que_o_màs/ano_corrente."}
           RUN utp/ut-msgs.p (INPUT "SHOW":U,
                              INPUT 54806, 
                              INPUT RETURN-VALUE).
           
           RETURN "NOK":U.
        
        END.
        
        IF (INT(SUBSTRING(INPUT FRAME fPage1 c-cod-period,1,2)) >  INT(SUBSTRING(pc-cod-period,1,2)) AND
            INT(SUBSTRING(INPUT FRAME fPage1 c-cod-period,3,4)) >= INT(SUBSTRING(pc-cod-period,3,4)))
           OR 
            INT(SUBSTRING(INPUT FRAME fPage1 c-cod-period,3,4)) > INT(SUBSTRING(pc-cod-period,3,4))
           THEN DO:
        
           {utp/ut-liter.i "Per°odo_n∆o_pode_ser_maior_que_o_£ltimo_per°odo_calculado."}
           RUN utp/ut-msgs.p (INPUT "SHOW":U,
                              INPUT 54806, 
                              INPUT RETURN-VALUE).
            
           
           RETURN "NOK":U.
        
        END.
    END.
    
    IF SUBSTRING(INPUT FRAME fPage1 c-mot-alteracao,4,1) = "" THEN DO:

       RUN utp/ut-msgs.p (INPUT "SHOW":U,
                          INPUT 54807, 
                          INPUT "").
        
       RETURN "NOK":U.

    END.
              
    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

