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
{include/i-prgvrs.i AQ0212A 2.00.00.016 } /*** 010016 ***/

/* Chamada a include do gerenciador de licen‡as. Necessario alterar os parametros */
/*                                                                                */
/* <programa>:  Informar qual o nome do programa.                                 */
/* <m¢dulo>:  Informar qual o m¢dulo a qual o programa pertence.                  */

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i AQ0212a MAQ}
&ENDIF

CREATE WIDGET-POOL.

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program        AQ0212a
&GLOBAL-DEFINE Version        2.00.00.016

&GLOBAL-DEFINE WindowType     Master/Detail

&GLOBAL-DEFINE Folder         NO
&GLOBAL-DEFINE InitialPage    1
&GLOBAL-DEFINE FolderLabels   

&GLOBAL-DEFINE page0widgets  fi-cod-estab-ini ~
                             fi-cod-estab-fim ~
                             fi-cod-rota-ini ~
                             fi-cod-rota-fim ~
                             fi-cod-transp-ini ~
                             fi-cod-transp-fim ~
                             fi-cdn-tip-veic-ini ~
                             fi-cdn-tip-veic-fim ~
                             fi-it-codigo-ini ~
                             fi-it-codigo-fim ~
                             fi-dat-inic-vigenc ~
                             fi-dat-fim-vigenc ~
                             IMAGE-5 IMAGE-6 ~
                             IMAGE-7 IMAGE-8 IMAGE-11 ~
                             IMAGE-12 IMAGE-13 IMAGE-14 ~
                             IMAGE-27 IMAGE-28 IMAGE-29 IMAGE-30


/* Parameters Definitions ---                                           */
DEFINE INPUT-OUTPUT PARAMETER pdt-dat-inic-vigenc LIKE preco-frete-coleta.dat-inic-vigenc NO-UNDO.
DEFINE INPUT-OUTPUT PARAMETER pdt-dat-fim-vigenc  LIKE preco-frete-coleta.dat-fim-vigenc  NO-UNDO.
DEFINE INPUT-OUTPUT PARAMETER pc-cod-estabel-ini  LIKE preco-frete-coleta.cod-estabel     NO-UNDO.
DEFINE INPUT-OUTPUT PARAMETER pc-cod-estabel-fim  LIKE preco-frete-coleta.cod-estabel     NO-UNDO.
DEFINE INPUT-OUTPUT PARAMETER pc-cod-rota-ini     LIKE preco-frete-coleta.cod-rota        NO-UNDO.
DEFINE INPUT-OUTPUT PARAMETER pc-cod-rota-fim     LIKE preco-frete-coleta.cod-rota        NO-UNDO.
DEFINE INPUT-OUTPUT PARAMETER pi-cod-transp-ini   LIKE preco-frete-coleta.cod-transp      NO-UNDO.
DEFINE INPUT-OUTPUT PARAMETER pi-cod-transp-fim   LIKE preco-frete-coleta.cod-transp      NO-UNDO.
DEFINE INPUT-OUTPUT PARAMETER pi-cdn-tip-veic-ini LIKE preco-frete-coleta.cdn-tip-veic    NO-UNDO.
DEFINE INPUT-OUTPUT PARAMETER pi-cdn-tip-veic-fim LIKE preco-frete-coleta.cdn-tip-veic    NO-UNDO.
DEFINE INPUT-OUTPUT PARAMETER pc-it-codigo-ini    LIKE preco-frete-coleta.it-codigo       NO-UNDO.
DEFINE INPUT-OUTPUT PARAMETER pc-it-codigo-fim    LIKE preco-frete-coleta.it-codigo       NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fpage0

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS rtToolBar RECT-3 IMAGE-5 IMAGE-6 RECT-4 ~
IMAGE-7 IMAGE-8 IMAGE-11 IMAGE-12 IMAGE-13 IMAGE-14 IMAGE-27 IMAGE-28 ~
IMAGE-29 IMAGE-30 fi-dat-inic-vigenc fi-dat-fim-vigenc fi-cod-estab-ini ~
fi-cod-estab-fim fi-cod-rota-ini fi-cod-rota-fim fi-cod-transp-ini ~
fi-cod-transp-fim fi-cdn-tip-veic-ini fi-cdn-tip-veic-fim fi-it-codigo-ini ~
fi-it-codigo-fim btOK btCancel btHelp2 
&Scoped-Define DISPLAYED-OBJECTS fi-dat-inic-vigenc fi-dat-fim-vigenc ~
fi-cod-estab-ini fi-cod-estab-fim fi-cod-rota-ini fi-cod-rota-fim ~
fi-cod-transp-ini fi-cod-transp-fim fi-cdn-tip-veic-ini fi-cdn-tip-veic-fim ~
fi-it-codigo-ini fi-it-codigo-fim 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR wWindow AS WIDGET-HANDLE NO-UNDO.

/* Menu Definitions                                                     */
DEFINE SUB-MENU smFile 
       MENU-ITEM miExit         LABEL "&Sair"          ACCELERATOR "CTRL-X".

DEFINE SUB-MENU smHelp 
       MENU-ITEM miContents     LABEL "&Conte£do"     
       MENU-ITEM miAbout        LABEL "&Sobre..."     .

DEFINE MENU mbMain MENUBAR
       SUB-MENU  smFile         LABEL "&Arquivo"      
       SUB-MENU  smHelp         LABEL "&Ajuda"        .


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

DEFINE VARIABLE fi-cdn-tip-veic-fim AS INTEGER FORMAT "99":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 6 BY .88 NO-UNDO.

DEFINE VARIABLE fi-cdn-tip-veic-ini AS INTEGER FORMAT "99":U INITIAL 0 
     LABEL "Tipo Ve¡culo" 
     VIEW-AS FILL-IN 
     SIZE 6 BY .88 NO-UNDO.

DEFINE VARIABLE fi-cod-estab-fim AS CHARACTER FORMAT "X(5)":U 
     VIEW-AS FILL-IN 
     SIZE 16.57 BY .88 NO-UNDO.

DEFINE VARIABLE fi-cod-estab-ini AS CHARACTER FORMAT "X(5)":U 
     LABEL "Estabelecimento" 
     VIEW-AS FILL-IN 
     SIZE 16.57 BY .88 NO-UNDO.

DEFINE VARIABLE fi-cod-rota-fim AS CHARACTER FORMAT "X(12)":U 
     VIEW-AS FILL-IN 
     SIZE 16.57 BY .88 NO-UNDO.

DEFINE VARIABLE fi-cod-rota-ini AS CHARACTER FORMAT "X(12)":U 
     LABEL "Rota" 
     VIEW-AS FILL-IN 
     SIZE 16.57 BY .88 NO-UNDO.

DEFINE VARIABLE fi-cod-transp-fim AS INTEGER FORMAT ">>,>>9":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 16.57 BY .88 NO-UNDO.

DEFINE VARIABLE fi-cod-transp-ini AS INTEGER FORMAT ">>,>>9":U INITIAL 0 
     LABEL "Transportador" 
     VIEW-AS FILL-IN 
     SIZE 16.57 BY .88 NO-UNDO.

DEFINE VARIABLE fi-dat-fim-vigenc AS DATE FORMAT "99/99/9999":U 
     VIEW-AS FILL-IN 
     SIZE 14.14 BY .88 NO-UNDO.

DEFINE VARIABLE fi-dat-inic-vigenc AS DATE FORMAT "99/99/9999":U 
     VIEW-AS FILL-IN 
     SIZE 13.43 BY .88 NO-UNDO.

DEFINE VARIABLE fi-it-codigo-fim AS CHARACTER FORMAT "X(16)":U 
     VIEW-AS FILL-IN 
     SIZE 17.57 BY .88 NO-UNDO.

DEFINE VARIABLE fi-it-codigo-ini AS CHARACTER FORMAT "X(16)":U 
     LABEL "Item" 
     VIEW-AS FILL-IN 
     SIZE 17.57 BY .88 NO-UNDO.

DEFINE IMAGE IMAGE-11
     FILENAME "image/im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-12
     FILENAME "image/im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-13
     FILENAME "image/im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-14
     FILENAME "image/im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-27
     FILENAME "image/im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-28
     FILENAME "image/im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-29
     FILENAME "image/im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-30
     FILENAME "image/im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-5
     FILENAME "image/im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-6
     FILENAME "image/im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-7
     FILENAME "image/im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-8
     FILENAME "image/im-las":U
     SIZE 3 BY .88.

DEFINE RECTANGLE RECT-3
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 80 BY 2.25.

DEFINE RECTANGLE RECT-4
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 80 BY 5.75.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 84 BY 1.42
     BGCOLOR 7 .


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fpage0
     fi-dat-inic-vigenc AT ROW 2.25 COL 23 COLON-ALIGNED NO-LABEL
     fi-dat-fim-vigenc AT ROW 2.25 COL 48.86 COLON-ALIGNED NO-LABEL
     fi-cod-estab-ini AT ROW 4.5 COL 20.14 COLON-ALIGNED
     fi-cod-estab-fim AT ROW 4.5 COL 49.14 COLON-ALIGNED NO-LABEL
     fi-cod-rota-ini AT ROW 5.5 COL 20.14 COLON-ALIGNED
     fi-cod-rota-fim AT ROW 5.5 COL 49.14 COLON-ALIGNED NO-LABEL
     fi-cod-transp-ini AT ROW 6.5 COL 20.14 COLON-ALIGNED
     fi-cod-transp-fim AT ROW 6.5 COL 49.14 COLON-ALIGNED NO-LABEL
     fi-cdn-tip-veic-ini AT ROW 7.5 COL 30.72 COLON-ALIGNED
     fi-cdn-tip-veic-fim AT ROW 7.5 COL 49 COLON-ALIGNED NO-LABEL
     fi-it-codigo-ini AT ROW 8.5 COL 19.14 COLON-ALIGNED
     fi-it-codigo-fim AT ROW 8.5 COL 49.14 COLON-ALIGNED NO-LABEL
     btOK AT ROW 10.5 COL 2
     btCancel AT ROW 10.5 COL 13
     btHelp2 AT ROW 10.54 COL 73
     "Abrangˆncia" VIEW-AS TEXT
          SIZE 9 BY .54 AT ROW 3.96 COL 6
     "Vigˆncia" VIEW-AS TEXT
          SIZE 6.29 BY .54 AT ROW 1.25 COL 5.72
     rtToolBar AT ROW 10.29 COL 1
     RECT-3 AT ROW 1.5 COL 3
     IMAGE-5 AT ROW 2.25 COL 38.72
     IMAGE-6 AT ROW 2.25 COL 48
     RECT-4 AT ROW 4.25 COL 3
     IMAGE-7 AT ROW 4.5 COL 38.86
     IMAGE-8 AT ROW 4.5 COL 48.14
     IMAGE-11 AT ROW 5.5 COL 38.86
     IMAGE-12 AT ROW 5.5 COL 48.14
     IMAGE-13 AT ROW 6.5 COL 38.86
     IMAGE-14 AT ROW 6.5 COL 48.14
     IMAGE-27 AT ROW 7.5 COL 38.86
     IMAGE-28 AT ROW 7.5 COL 48.14
     IMAGE-29 AT ROW 8.5 COL 38.86
     IMAGE-30 AT ROW 8.5 COL 48.14
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 90.14 BY 21.33
         FONT 1.


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
         HEIGHT             = 10.79
         WIDTH              = 83.29
         MAX-HEIGHT         = 38.63
         MAX-WIDTH          = 182.86
         VIRTUAL-HEIGHT     = 38.63
         VIRTUAL-WIDTH      = 182.86
         MAX-BUTTON         = no
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

ASSIGN {&WINDOW-NAME}:MENUBAR    = MENU mbMain:HANDLE.
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
ASSIGN 
       IMAGE-11:HIDDEN IN FRAME fpage0           = TRUE.

ASSIGN 
       IMAGE-12:HIDDEN IN FRAME fpage0           = TRUE.

ASSIGN 
       IMAGE-13:HIDDEN IN FRAME fpage0           = TRUE.

ASSIGN 
       IMAGE-14:HIDDEN IN FRAME fpage0           = TRUE.

ASSIGN 
       IMAGE-27:HIDDEN IN FRAME fpage0           = TRUE.

ASSIGN 
       IMAGE-28:HIDDEN IN FRAME fpage0           = TRUE.

ASSIGN 
       IMAGE-29:HIDDEN IN FRAME fpage0           = TRUE.

ASSIGN 
       IMAGE-30:HIDDEN IN FRAME fpage0           = TRUE.

ASSIGN 
       IMAGE-5:HIDDEN IN FRAME fpage0           = TRUE.

ASSIGN 
       IMAGE-6:HIDDEN IN FRAME fpage0           = TRUE.

ASSIGN 
       IMAGE-7:HIDDEN IN FRAME fpage0           = TRUE.

ASSIGN 
       IMAGE-8:HIDDEN IN FRAME fpage0           = TRUE.

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
OR CHOOSE OF MENU-ITEM miExit IN MENU mbMain DO:

    APPLY "CLOSE":U TO THIS-PROCEDURE.
    RETURN 'NOK'.
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
    RUN pi-atualiza-params IN THIS-PROCEDURE.    
    IF RETURN-VALUE = "OK":U THEN DO:
        APPLY "CLOSE":U TO THIS-PROCEDURE.
        RETURN 'OK':U.
    END. 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME miAbout
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL miAbout wWindow
ON CHOOSE OF MENU-ITEM miAbout /* Sobre... */
DO:
  {include/sobre.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wWindow 


/*:T--- L¢gica para inicializa‡Æo do programam ---*/
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
    RUN pi-atualiza-campos IN THIS-PROCEDURE.
    
    ENABLE btOk 
           btCancel 
           WITH FRAME fPage0.    
    
    RETURN 'OK':U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-atualiza-campos wWindow 
PROCEDURE pi-atualiza-campos :
/*------------------------------------------------------------------------------
  Purpose: Atualizar campos da tela com os valores passados por parametro.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    ASSIGN fi-dat-inic-vigenc  = pdt-dat-inic-vigenc
           fi-dat-fim-vigenc   = pdt-dat-fim-vigenc
           fi-cod-estab-ini    = pc-cod-estabel-ini
           fi-cod-estab-fim    = pc-cod-estabel-fim
           fi-cod-rota-ini     = pc-cod-rota-ini
           fi-cod-rota-fim     = pc-cod-rota-fim
           fi-cod-transp-ini   = pi-cod-transp-ini
           fi-cod-transp-fim   = pi-cod-transp-fim
           fi-cdn-tip-veic-ini = pi-cdn-tip-veic-ini
           fi-cdn-tip-veic-fim = pi-cdn-tip-veic-fim
           fi-it-codigo-ini    = pc-it-codigo-ini
           fi-it-codigo-fim    = pc-it-codigo-fim.

    DISPLAY fi-dat-inic-vigenc
            fi-dat-fim-vigenc
            fi-cod-estab-ini
            fi-cod-estab-fim
            fi-cod-rota-ini
            fi-cod-rota-fim
            fi-cod-transp-ini
            fi-cod-transp-fim
            fi-cdn-tip-veic-ini
            fi-cdn-tip-veic-fim
            fi-it-codigo-ini
            fi-it-codigo-fim
            WITH FRAME fPage0.

    RETURN 'OK':U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-atualiza-params wWindow 
PROCEDURE pi-atualiza-params :
/*------------------------------------------------------------------------------
  Purpose: Atualiza parametros com base nos valores informados em tela
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    RUN pi-valida-faixas IN THIS-PROCEDURE.
    IF RETURN-VALUE = "NOK" THEN 
        RETURN "NOK":U.

    ASSIGN  pdt-dat-inic-vigenc   = INPUT FRAME fPage0  fi-dat-inic-vigenc
            pdt-dat-fim-vigenc    = INPUT FRAME fPage0  fi-dat-fim-vigenc
            pc-cod-estabel-ini    = INPUT FRAME fPage0  fi-cod-estab-ini
            pc-cod-estabel-fim    = INPUT FRAME fPage0  fi-cod-estab-fim
            pc-cod-rota-ini       = INPUT FRAME fPage0  fi-cod-rota-ini
            pc-cod-rota-fim       = INPUT FRAME fPage0  fi-cod-rota-fim
            pi-cod-transp-ini     = INPUT FRAME fPage0  fi-cod-transp-ini
            pi-cod-transp-fim     = INPUT FRAME fPage0  fi-cod-transp-fim
            pi-cdn-tip-veic-ini   = INPUT FRAME fPage0  fi-cdn-tip-veic-ini
            pi-cdn-tip-veic-fim   = INPUT FRAME fPage0  fi-cdn-tip-veic-fim
            pc-it-codigo-ini      = INPUT FRAME fPage0  fi-it-codigo-ini
            pc-it-codigo-fim      = INPUT FRAME fPage0  fi-it-codigo-fim.

    RETURN 'OK':U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-valida-faixas wWindow 
PROCEDURE pi-valida-faixas :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE VARIABLE c-param AS CHARACTER   NO-UNDO.

   IF INPUT FRAME fPage0 fi-dat-fim-vigenc        < INPUT FRAME fPage0  fi-dat-inic-vigenc THEN DO:
       {utp/ut-liter.i "Data Vigˆncia Final" * }
       ASSIGN c-param = RETURN-VALUE.
       {utp/ut-liter.i "Data Vigˆncia Inicial" * }
       ASSIGN c-param = c-param + "~~" + RETURN-VALUE.
   END.
   ELSE IF INPUT FRAME fPage0 fi-cod-estab-fim    < INPUT FRAME fPage0  fi-cod-estab-ini   THEN DO:
       {utp/ut-liter.i "Estabelecimento Final" * }
       ASSIGN c-param = RETURN-VALUE.
       {utp/ut-liter.i "Estabelecimento Inicial" * }
       ASSIGN c-param = c-param + "~~" + RETURN-VALUE.
   END.
   ELSE IF INPUT FRAME fPage0 fi-cod-rota-fim     < INPUT FRAME fPage0  fi-cod-rota-ini   THEN DO:
       {utp/ut-liter.i "Rota Final" * }
       ASSIGN c-param = RETURN-VALUE.
       {utp/ut-liter.i "Rota Inicial" * }
       ASSIGN c-param = c-param + "~~" + RETURN-VALUE.
   END.
   ELSE IF INPUT FRAME fPage0 fi-cod-transp-fim   < INPUT FRAME fPage0  fi-cod-transp-ini  THEN DO:
       {utp/ut-liter.i "Transportador Final" * }
       ASSIGN c-param = RETURN-VALUE.
       {utp/ut-liter.i "Transportador Inicial" * }
       ASSIGN c-param = c-param + "~~" + RETURN-VALUE.
   END.
   ELSE IF INPUT FRAME fPage0 fi-cdn-tip-veic-fim < INPUT FRAME fPage0  fi-cdn-tip-veic-ini  THEN DO:
       {utp/ut-liter.i "Tipo Ve¡culo Final" * }
       ASSIGN c-param = RETURN-VALUE.
       {utp/ut-liter.i "Tipo Ve¡culo Inicial" * }
       ASSIGN c-param = c-param + "~~" + RETURN-VALUE.
   END.
   ELSE IF INPUT FRAME fPage0 fi-it-codigo-fim    < INPUT FRAME fPage0  fi-it-codigo-ini THEN DO:
       {utp/ut-liter.i "Item Final" * }
       ASSIGN c-param = RETURN-VALUE.
       {utp/ut-liter.i "Item Inicial" * }
       ASSIGN c-param = c-param + "~~" + RETURN-VALUE.
   END.

   IF c-param <> "" THEN DO:
        RUN utp/ut-msgs.p(INPUT 'SHOW', /* &1 deve ser maior ou igual a &2 */
                          INPUT 7017, 
                          INPUT c-param).
        RETURN "NOK":U.
   END.

   RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

