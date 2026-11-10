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
{include/i-prgvrs.i AQ0305A 2.00.00.005 } /*** 010005 ***/ 

/* Chamada a include do gerenciador de licen‡as. Necessario alterar os parametros */
/*                                                                                */
/* <programa>:  Informar qual o nome do programa.                                 */
/* <m¢dulo>:  Informar qual o m¢dulo a qual o programa pertence.                  */

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i AQ0305A MAQ}
&ENDIF

CREATE WIDGET-POOL.

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program        
&GLOBAL-DEFINE Version        2.00.00.005

&GLOBAL-DEFINE WindowType     Master

&GLOBAL-DEFINE Folder         NO
&GLOBAL-DEFINE InitialPage    1
&GLOBAL-DEFINE FolderLabels   

&GLOBAL-DEFINE page0Widgets   btOK btCancel fi-codigo-rejei fi-cod-depos ed-observacao 


/* Parameters Definitions ---                                           */
DEFINE INPUT        PARAMETER pc-cod-estabel AS CHARACTER NO-UNDO.
DEFINE INPUT-OUTPUT PARAMETER pi-cod-rejei   AS INTEGER   NO-UNDO.
DEFINE INPUT-OUTPUT PARAMETER pc-cod-depos   AS CHARACTER NO-UNDO.
DEFINE INPUT-OUTPUT PARAMETER pc-observacao  AS CHARACTER NO-UNDO.
DEFINE       OUTPUT PARAMETER pl-ok          AS LOGICAL   NO-UNDO.

/* Local Variable Definitions ---                                       */
DEFINE VARIABLE h-boin084   AS HANDLE  NO-UNDO.
DEFINE VARIABLE h-boin047   AS HANDLE  NO-UNDO.
DEFINE VARIABLE h-boad107na AS HANDLE  NO-UNDO.

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
&Scoped-Define ENABLED-OBJECTS rtToolBar RECT-1 fi-codigo-rejei ~
fi-desc-rejei fi-cod-depos fi-nome ed-observacao btOK btCancel 
&Scoped-Define DISPLAYED-OBJECTS fi-codigo-rejei fi-desc-rejei fi-cod-depos ~
fi-nome ed-observacao 

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

DEFINE BUTTON btOK 
     LABEL "OK" 
     SIZE 10 BY 1.

DEFINE VARIABLE ed-observacao AS CHARACTER 
     VIEW-AS EDITOR MAX-CHARS 100 SCROLLBAR-VERTICAL
     SIZE 44.14 BY 5.5 NO-UNDO.

DEFINE VARIABLE fi-cod-depos AS CHARACTER FORMAT "x(3)" 
     LABEL "Dep¢sito" 
     VIEW-AS FILL-IN 
     SIZE 5.72 BY .88.

DEFINE VARIABLE fi-codigo-rejei AS INTEGER FORMAT ">>9":U INITIAL 0 
     LABEL "Cod. Rejei." 
     VIEW-AS FILL-IN 
     SIZE 5.72 BY .88 NO-UNDO.

DEFINE VARIABLE fi-desc-rejei AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 29.43 BY .88 NO-UNDO.

DEFINE VARIABLE fi-nome AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 29.43 BY .88 NO-UNDO.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 50 BY 2.75.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 50 BY 1.42
     BGCOLOR 7 .


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fpage0
     fi-codigo-rejei AT ROW 1.42 COL 9.72 COLON-ALIGNED
     fi-desc-rejei AT ROW 1.42 COL 15.43 COLON-ALIGNED NO-LABEL
     fi-cod-depos AT ROW 2.42 COL 9.72 COLON-ALIGNED
     fi-nome AT ROW 2.42 COL 15.43 COLON-ALIGNED NO-LABEL
     ed-observacao AT ROW 4.71 COL 4 NO-LABEL
     btOK AT ROW 10.67 COL 2
     btCancel AT ROW 10.67 COL 13
     "Observa‡Æo" VIEW-AS TEXT
          SIZE 9.29 BY .54 AT ROW 3.96 COL 3.72
     rtToolBar AT ROW 10.46 COL 1
     RECT-1 AT ROW 1 COL 1 WIDGET-ID 2
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 50 BY 10.96
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
         HEIGHT             = 10.96
         WIDTH              = 50
         MAX-HEIGHT         = 18.29
         MAX-WIDTH          = 114.14
         VIRTUAL-HEIGHT     = 18.29
         VIRTUAL-WIDTH      = 114.14
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
    RETURN "NOK":U.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btOK
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btOK wWindow
ON CHOOSE OF btOK IN FRAME fpage0 /* OK */
DO:    
    RUN validateFields IN THIS-PROCEDURE.
    IF RETURN-VALUE = 'NOK' THEN RETURN NO-APPLY.

    ASSIGN pi-cod-rejei = INPUT FRAME fPage0 fi-codigo-rejei
           pc-observacao   = INPUT FRAME fPage0 ed-observacao
           pc-cod-depos    = INPUT FRAME fPage0 fi-cod-depos
           pl-ok         = YES.

    APPLY "CLOSE":U TO THIS-PROCEDURE.
    RETURN "OK":U.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fi-cod-depos
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-cod-depos wWindow
ON ENTRY OF fi-cod-depos IN FRAME fpage0 /* Dep¢sito */
DO:
   APPLY 'LEAVE':U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-cod-depos wWindow
ON F5 OF fi-cod-depos IN FRAME fpage0 /* Dep¢sito */
DO:
     ASSIGN l-implanta = NO.
    {include/zoomvar.i &prog-zoom="inzoom/z01in084.w"
                     &campo=fi-cod-depos
                     &campozoom=cod-depos
                     &campo2=fi-nome
                     &campozoom2=nome} 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-cod-depos wWindow
ON LEAVE OF fi-cod-depos IN FRAME fpage0 /* Dep¢sito */
DO:    
  {include/leave.i &tabela=deposito
                   &atributo-ref=nome
                   &variavel-ref=fi-nome
                   &where="deposito.cod-depos = input frame fPage0 fi-cod-depos"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-cod-depos wWindow
ON MOUSE-SELECT-DBLCLICK OF fi-cod-depos IN FRAME fpage0 /* Dep¢sito */
DO:
  APPLY 'F5':U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fi-codigo-rejei
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-codigo-rejei wWindow
ON ENTRY OF fi-codigo-rejei IN FRAME fpage0 /* Cod. Rejei. */
DO:
   APPLY 'LEAVE':U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-codigo-rejei wWindow
ON F5 OF fi-codigo-rejei IN FRAME fpage0 /* Cod. Rejei. */
DO:
      assign l-implanta = YES.
     {include/zoomvar.i &prog-zoom="inzoom/z01in047.w"
                     &campo=fi-codigo-rejei
                     &campozoom=codigo-rejei}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-codigo-rejei wWindow
ON LEAVE OF fi-codigo-rejei IN FRAME fpage0 /* Cod. Rejei. */
DO:
   {include/leave.i &tabela=cod-rejeicao
                     &atributo-ref=descricao
                     &variavel-ref=fi-desc-rejei
                     &where="cod-rejeicao.codigo-rejei = input frame fPage0 fi-codigo-rejei"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-codigo-rejei wWindow
ON MOUSE-SELECT-DBLCLICK OF fi-codigo-rejei IN FRAME fpage0 /* Cod. Rejei. */
DO:
  APPLY 'F5':U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wWindow 


/*:T--- L¢gica para inicializa‡Æo do programam ---*/
 fi-codigo-rejei:LOAD-MOUSE-POINTER("image/lupa.cur":U) IN FRAME fPage0.
{window/mainblock.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterDestroyInterface wWindow 
PROCEDURE afterDestroyInterface :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    IF VALID-HANDLE(h-boin084) THEN DO:
        RUN destroy IN h-boin084.
        ASSIGN h-boin084 = ?.
    END.

    IF VALID-HANDLE(h-boin047) THEN DO:
        RUN destroy IN h-boin047.
        ASSIGN h-boin047 = ?.
    END.
    
    IF VALID-HANDLE(h-boad107na) THEN DO:
        RUN destroy IN h-boad107na.
        ASSIGN h-boad107na = ?.
    END.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterInitializeInterface wWindow 
PROCEDURE afterInitializeInterface :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    RUN initializeDBOs IN THIS-PROCEDURE.
    
    IF pc-cod-depos = "" THEN DO:
        IF VALID-HANDLE(h-boad107na) THEN DO:
            RUN goToKey IN h-boad107na(INPUT pc-cod-estabel).
            IF RETURN-VALUE = "OK":U THEN DO:
                RUN getCharField IN h-boad107na(INPUT 'dep-rej-cq':U, OUTPUT pc-cod-depos).
            END.        
        END.
    END.

   ASSIGN fi-codigo-rejei = pi-cod-rejei
          fi-cod-depos    = pc-cod-depos  
          ed-observacao   = pc-observacao.

   DISPLAY fi-codigo-rejei 
           fi-cod-depos
           ed-observacao
           WITH FRAME fPage0.

   APPLY 'LEAVE':U TO fi-codigo-rejei IN FRAME fPage0. 
   APPLY 'LEAVE':U TO fi-cod-depos    IN FRAME fPage0.

    RETURN "OK".
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE initializeDBOs wWindow 
PROCEDURE initializeDBOs :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    
    IF NOT VALID-HANDLE(h-boin084) THEN
        RUN inbo/boin084.p PERSISTENT SET h-boin084.
    IF VALID-HANDLE(h-boin084) THEN
        RUN openQueryStatic IN h-boin084(INPUT 'Main':U).

    IF NOT VALID-HANDLE(h-boin047) THEN
        RUN inbo/boin047.p PERSISTENT SET h-boin047.
    IF VALID-HANDLE(h-boin047) THEN
        RUN openQueryStatic IN h-boin047(INPUT 'Default':U).

     IF NOT VALID-HANDLE(h-boad107na) THEN
        RUN adbo/boad107na.p PERSISTENT SET h-boad107na.
    IF VALID-HANDLE(h-boad107na) THEN
        RUN openQueryStatic IN h-boad107na(INPUT 'Main':U).
        
        
    RETURN "OK".
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validateFields wWindow 
PROCEDURE validateFields :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    
    DEFINE VARIABLE l-error-number AS INTEGER INITIAL ?  NO-UNDO.
    DEFINE VARIABLE c-error-desc   AS CHARACTER NO-UNDO.

    DEFINE VARIABLE l-ind-dep-rej AS LOGICAL     NO-UNDO.
    
    IF VALID-HANDLE(h-boin047) THEN DO:
        RUN goToKey IN h-boin047(INPUT INPUT FRAME fPage0 fi-codigo-rejei).
        IF RETURN-VALUE = "NOK" THEN DO:
            {utp/ut-table.i mgind cod-rejeicao 1}
            ASSIGN l-error-number = 2
                   c-error-desc   = RETURN-VALUE.
        END.
    END.

    IF VALID-HANDLE(h-boin084) AND l-error-number = ? THEN DO:
        RUN goToKey IN h-boin084(INPUT INPUT FRAME fPage0 fi-cod-depos).
        IF RETURN-VALUE = "NOK" THEN DO:
            {utp/ut-table.i mgind deposito 1}
            ASSIGN l-error-number = 2
                    c-error-desc   = RETURN-VALUE.
        END.
        ELSE DO:
            RUN getLogField IN h-boin084(INPUT 'ind-dep-rej', OUTPUT l-ind-dep-rej).
            IF NOT l-ind-dep-rej THEN DO:
                ASSIGN l-error-number = 1015
                       c-error-desc   = ''.

            END.
        END.
    END.

    IF l-error-number <> ? THEN
        RUN utp/ut-msgs.p (INPUT 'SHOW':U,
                           INPUT l-error-number,
                           INPUT c-error-desc).

    RETURN IF l-error-number = ? THEN 'OK':U ELSE 'NOK':U.
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

