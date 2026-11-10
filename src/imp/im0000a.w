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
{include/i-prgvrs.i IM0000A 2.00.00.001}  /*** 010001 ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i IM0000A MIM}
&ENDIF

CREATE WIDGET-POOL.

/* ***************************  Definitions  ************************** */

/* Parameters Definitions ---                                           */

DEFINE INPUT PARAMETER          pc-titulo-programa AS CHAR NO-UNDO.
DEFINE INPUT-OUTPUT PARAMETER   pc-formula         AS CHAR NO-UNDO.

/* Local Variable Definitions ---                                       */
DEF VAR c-formula  AS CHAR NO-UNDO.
DEF VAR c-variavel AS CHAR NO-UNDO.

{cdp/cdcfgdis.i}    /* Definiá∆o pre-processador */
{cdp/cdcfgmat.i}    /* Definiá∆o pre-processador */

&IF defined(bf-mat-comex) &then
   {cdp/cdapi031.i}
&else
   {cdp/cdapi020.i}
&endif

{cdp/cd0666.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME DEFAULT-FRAME

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS e-formula bt-valida BUTTON-7 bt-variaveis ~
BUTTON-3 BUTTON-1 BUTTON-2 BUTTON-4 BUTTON-6 BUTTON-5 btOK btCancel btHelp ~
RECT-1 rtToolBar 
&Scoped-Define DISPLAYED-OBJECTS e-formula 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR C-Win AS WIDGET-HANDLE NO-UNDO.

/* Menu Definitions                                                     */
DEFINE MENU POPUP-MENU-e-formula 
       MENU-ITEM m_Variaveis    LABEL "Vari†veis:"    
       RULE
       MENU-ITEM m_VA_-_Valor_Aduaneiro LABEL "VA - Valor Aduaneiro"
       MENU-ITEM m_DA_-_Despesas_Aduaneiras LABEL "DA - Despesas Aduaneiras"
       MENU-ITEM m_a_-_Alquota_do_Imposto_de_I LABEL "a - Al°quota do Imposto de Importaá∆o"
       MENU-ITEM m_b_-_Alquota_do_IPI LABEL "b - Al°quota do IPI"
       MENU-ITEM m_c_-_Alquota_do_PISPASEP_Imp LABEL "c - Al°quota do PIS/PASEP Importaá∆o"
       MENU-ITEM m_d_-_Alquota_do_COFINS_Impor LABEL "d - Al°quota do COFINS Importaá∆o"
       MENU-ITEM m_e_-_Alquota_do_ICMS LABEL "e - Al°quota do ICMS".


/* Definitions of the field level widgets                               */
DEFINE BUTTON bt-valida 
     IMAGE-UP FILE "image/im-sav.bmp":U
     LABEL "bt-valida" 
     SIZE 5 BY 1.13 TOOLTIP "Valida F¢rmula".

DEFINE BUTTON bt-variaveis 
     LABEL "Vari†veis" 
     SIZE 15 BY 1.13.

DEFINE BUTTON btCancel 
     LABEL "Cancelar" 
     SIZE 10 BY 1.

DEFINE BUTTON btHelp 
     LABEL "Ajuda" 
     SIZE 10 BY 1.

DEFINE BUTTON btOK 
     LABEL "OK" 
     SIZE 10 BY 1.

DEFINE BUTTON BUTTON-1 
     LABEL "-" 
     SIZE 5 BY 1.13
     FONT 0.

DEFINE BUTTON BUTTON-2 
     LABEL "*" 
     SIZE 5 BY 1.13
     FONT 0.

DEFINE BUTTON BUTTON-3 
     LABEL "+" 
     SIZE 5 BY 1.13
     FONT 0.

DEFINE BUTTON BUTTON-4 
     LABEL "/" 
     SIZE 5 BY 1.13
     FONT 0.

DEFINE BUTTON BUTTON-5 
     LABEL ")" 
     SIZE 5 BY 1.13
     FONT 0.

DEFINE BUTTON BUTTON-6 
     LABEL "(" 
     SIZE 5 BY 1.13
     FONT 0.

DEFINE BUTTON BUTTON-7 
     IMAGE-UP FILE "image/im-calc2.bmp":U
     LABEL "Button 7" 
     SIZE 5 BY 1.13 TOOLTIP "Simula a f¢rmula.".

DEFINE VARIABLE e-formula AS CHARACTER 
     VIEW-AS EDITOR MAX-CHARS 500 SCROLLBAR-VERTICAL
     SIZE 70 BY 4 TOOLTIP "Bot∆o direito para visualizar as vari†veis." NO-UNDO.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 90 BY 8.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE  
     SIZE 89.72 BY 1.42
     BGCOLOR 7 .


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME DEFAULT-FRAME
     e-formula AT ROW 2.5 COL 11 HELP
          "Informe a f¢rmula." NO-LABEL
     bt-valida AT ROW 2.5 COL 81
     BUTTON-7 AT ROW 3.5 COL 81
     bt-variaveis AT ROW 6.5 COL 11
     BUTTON-3 AT ROW 6.5 COL 51
     BUTTON-1 AT ROW 6.5 COL 56
     BUTTON-2 AT ROW 6.5 COL 61
     BUTTON-4 AT ROW 6.5 COL 66
     BUTTON-6 AT ROW 6.5 COL 71
     BUTTON-5 AT ROW 6.5 COL 76
     btOK AT ROW 9.21 COL 2
     btCancel AT ROW 9.21 COL 13
     btHelp AT ROW 9.21 COL 79.86
     RECT-1 AT ROW 1 COL 1
     rtToolBar AT ROW 9 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 90 BY 9.42
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
         TITLE              = ""
         HEIGHT             = 9.42
         WIDTH              = 90
         MAX-HEIGHT         = 28
         MAX-WIDTH          = 146.29
         VIRTUAL-HEIGHT     = 28
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



/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW C-Win
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME DEFAULT-FRAME
                                                                        */
ASSIGN 
       e-formula:POPUP-MENU IN FRAME DEFAULT-FRAME       = MENU POPUP-MENU-e-formula:HANDLE.

IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(C-Win)
THEN C-Win:HIDDEN = no.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME C-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL C-Win C-Win
ON END-ERROR OF C-Win
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL C-Win C-Win
ON WINDOW-CLOSE OF C-Win
DO:
  /* This event will close the window and terminate the procedure.  */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-valida
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-valida C-Win
ON CHOOSE OF bt-valida IN FRAME DEFAULT-FRAME /* bt-valida */
DO:
    ASSIGN INPUT FRAME {&FRAME-NAME} e-formula.
    ASSIGN c-formula = e-formula.

    /* Formula calculo base PIS */
    FOR EACH tt-formula:
        DELETE tt-formula.
    END.

    FOR EACH tt-var:
        DELETE tt-var.
    END.

    CREATE tt-formula.
    ASSIGN tt-formula.formula = c-formula
           tt-formula.cod-versao-integracao = 001.

    CREATE tt-var.
    ASSIGN tt-var.nome      = "VA"
           tt-var.valor     = 2
           tt-var.tipo-res  = 1.
    
    CREATE tt-var.
    ASSIGN tt-var.nome      = "DA"
           tt-var.valor     = 1
           tt-var.tipo-res  = 1.
    
    CREATE tt-var.
    ASSIGN tt-var.nome      = "a"
           tt-var.valor     = 10 / 100
           tt-var.tipo-res  = 1.
    
    CREATE tt-var.
    ASSIGN tt-var.nome      = "b"
           tt-var.valor     = 10 / 100
           tt-var.tipo-res  = 1.

    CREATE tt-var.
    ASSIGN tt-var.nome      = "c"
           tt-var.valor     = 1.65 / 100
           tt-var.tipo-res  = 1.  
    
    CREATE tt-var.
    ASSIGN tt-var.nome      = "d"
           tt-var.valor     = 7.6 / 100
           tt-var.tipo-res  = 1.
    
    CREATE tt-var.
    ASSIGN tt-var.nome      = "e"
           tt-var.valor     = 17 / 100
           tt-var.tipo-res  = 1.
    
    &IF defined(bf-mat-comex) &then
       RUN cdp/cdapi031.p (INPUT-OUTPUT TABLE tt-formula,
                           INPUT TABLE tt-var,
                           INPUT-OUTPUT TABLE tt-erro,
                           INPUT YES).
    &else
       RUN cdp/cdapi020.p (INPUT-OUTPUT TABLE tt-formula,
                           INPUT TABLE tt-var,
                           INPUT-OUTPUT TABLE tt-erro,
                           INPUT YES).
    &endif

    IF CAN-FIND(FIRST tt-erro) THEN DO:
        FOR EACH tt-erro.
            MESSAGE tt-erro.cd-erro "-" tt-erro.mensagem VIEW-AS ALERT-BOX ERROR.
        END.
    END.
    ELSE 
        /* Inicio -- Projeto Internacional */
        DO:
        {utp/ut-liter.i "Formula_OK" *}
        MESSAGE RETURN-VALUE + "!" VIEW-AS ALERT-BOX INFORMATION.
        END. 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-variaveis
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-variaveis C-Win
ON CHOOSE OF bt-variaveis IN FRAME DEFAULT-FRAME /* Vari†veis */
DO:
    ASSIGN c-variavel = "".
    RUN imp/im0000aa.w (INPUT "im0000a.w",
                        OUTPUT c-variavel).
    ASSIGN INPUT FRAME {&FRAME-NAME} e-formula.
    ASSIGN e-formula = e-formula + " " + c-variavel.
    DISP e-formula WITH FRAME {&FRAME-NAME}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btCancel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btCancel C-Win
ON CHOOSE OF btCancel IN FRAME DEFAULT-FRAME /* Cancelar */
DO:
    APPLY "CLOSE":U TO THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btHelp
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btHelp C-Win
ON CHOOSE OF btHelp IN FRAME DEFAULT-FRAME /* Ajuda */
DO:
    {include/ajuda.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btOK
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btOK C-Win
ON CHOOSE OF btOK IN FRAME DEFAULT-FRAME /* OK */
DO:
    ASSIGN INPUT FRAME {&FRAME-NAME} e-formula.
    ASSIGN pc-formula = e-formula.
    APPLY "CLOSE":U TO THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-1 C-Win
ON CHOOSE OF BUTTON-1 IN FRAME DEFAULT-FRAME /* - */
DO:
    ASSIGN INPUT FRAME {&FRAME-NAME} e-formula.
    ASSIGN e-formula = e-formula + " -".
    DISP e-formula WITH FRAME {&FRAME-NAME}.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-2 C-Win
ON CHOOSE OF BUTTON-2 IN FRAME DEFAULT-FRAME /* * */
DO:
    ASSIGN INPUT FRAME {&FRAME-NAME} e-formula.
    ASSIGN e-formula = e-formula + " *".
    DISP e-formula WITH FRAME {&FRAME-NAME}.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-3
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-3 C-Win
ON CHOOSE OF BUTTON-3 IN FRAME DEFAULT-FRAME /* + */
DO:
    ASSIGN INPUT FRAME {&FRAME-NAME} e-formula.
    ASSIGN e-formula = e-formula + " +".
    DISP e-formula WITH FRAME {&FRAME-NAME}.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-4
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-4 C-Win
ON CHOOSE OF BUTTON-4 IN FRAME DEFAULT-FRAME /* / */
DO:
    ASSIGN INPUT FRAME {&FRAME-NAME} e-formula.
    ASSIGN e-formula = e-formula + " /".
    DISP e-formula WITH FRAME {&FRAME-NAME}.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-5
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-5 C-Win
ON CHOOSE OF BUTTON-5 IN FRAME DEFAULT-FRAME /* ) */
DO:
    ASSIGN INPUT FRAME {&FRAME-NAME} e-formula.
    ASSIGN e-formula = e-formula + " )".
    DISP e-formula WITH FRAME {&FRAME-NAME}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-6
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-6 C-Win
ON CHOOSE OF BUTTON-6 IN FRAME DEFAULT-FRAME /* ( */
DO:
    ASSIGN INPUT FRAME {&FRAME-NAME} e-formula.
    ASSIGN e-formula = e-formula + " (".
    DISP e-formula WITH FRAME {&FRAME-NAME}.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-7
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-7 C-Win
ON CHOOSE OF BUTTON-7 IN FRAME DEFAULT-FRAME /* Button 7 */
DO:
    ASSIGN INPUT FRAME {&FRAME-NAME} e-formula.
    ASSIGN c-formula = e-formula.
    RUN imp/im0000ab.w (INPUT c-formula).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_a_-_Alquota_do_Imposto_de_I
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_a_-_Alquota_do_Imposto_de_I C-Win
ON CHOOSE OF MENU-ITEM m_a_-_Alquota_do_Imposto_de_I /* a - Al°quota do Imposto de Importaá∆o */
DO:
    ASSIGN INPUT FRAME {&FRAME-NAME} e-formula.
    ASSIGN e-formula = e-formula + " a".
    DISP e-formula WITH FRAME {&FRAME-NAME}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_b_-_Alquota_do_IPI
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_b_-_Alquota_do_IPI C-Win
ON CHOOSE OF MENU-ITEM m_b_-_Alquota_do_IPI /* b - Al°quota do IPI */
DO:
    ASSIGN INPUT FRAME {&FRAME-NAME} e-formula.
    ASSIGN e-formula = e-formula + " b".
    DISP e-formula WITH FRAME {&FRAME-NAME}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_c_-_Alquota_do_PISPASEP_Imp
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_c_-_Alquota_do_PISPASEP_Imp C-Win
ON CHOOSE OF MENU-ITEM m_c_-_Alquota_do_PISPASEP_Imp /* c - Al°quota do PIS/PASEP Importaá∆o */
DO:
    ASSIGN INPUT FRAME {&FRAME-NAME} e-formula.
    ASSIGN e-formula = e-formula + " c".
    DISP e-formula WITH FRAME {&FRAME-NAME}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_DA_-_Despesas_Aduaneiras
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_DA_-_Despesas_Aduaneiras C-Win
ON CHOOSE OF MENU-ITEM m_DA_-_Despesas_Aduaneiras /* DA - Despesas Aduaneiras */
DO:
    ASSIGN INPUT FRAME {&FRAME-NAME} e-formula.
    ASSIGN e-formula = e-formula + " DA".
    DISP e-formula WITH FRAME {&FRAME-NAME}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_d_-_Alquota_do_COFINS_Impor
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_d_-_Alquota_do_COFINS_Impor C-Win
ON CHOOSE OF MENU-ITEM m_d_-_Alquota_do_COFINS_Impor /* d - Al°quota do COFINS Importaá∆o */
DO:
    ASSIGN INPUT FRAME {&FRAME-NAME} e-formula.
    ASSIGN e-formula = e-formula + " d".
    DISP e-formula WITH FRAME {&FRAME-NAME}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_e_-_Alquota_do_ICMS
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_e_-_Alquota_do_ICMS C-Win
ON CHOOSE OF MENU-ITEM m_e_-_Alquota_do_ICMS /* e - Al°quota do ICMS */
DO:
    ASSIGN INPUT FRAME {&FRAME-NAME} e-formula.
    ASSIGN e-formula = e-formula + " e".
    DISP e-formula WITH FRAME {&FRAME-NAME}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_VA_-_Valor_Aduaneiro
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_VA_-_Valor_Aduaneiro C-Win
ON CHOOSE OF MENU-ITEM m_VA_-_Valor_Aduaneiro /* VA - Valor Aduaneiro */
DO:
    ASSIGN INPUT FRAME {&FRAME-NAME} e-formula.
    ASSIGN e-formula = e-formula + " VA".
    DISP e-formula WITH FRAME {&FRAME-NAME}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK C-Win 


/* ***************************  Main Block  *************************** */

/* Set CURRENT-WINDOW: this will parent dialog-boxes and frames.        */
ASSIGN CURRENT-WINDOW                = {&WINDOW-NAME} 
       THIS-PROCEDURE:CURRENT-WINDOW = {&WINDOW-NAME}.

ASSIGN e-formula    = trim(pc-formula)
       c-win:TITLE  = pc-titulo-programa + " - IM0000A - 2.00.00.000".

DISP e-formula WITH FRAME {&FRAME-NAME}.

/* The CLOSE event can be used from inside or outside the procedure to  */
/* terminate it.                                                        */
ON CLOSE OF THIS-PROCEDURE 
   RUN disable_UI.

/* Best default for GUI applications is...                              */
PAUSE 0 BEFORE-HIDE.

/* Now enable the interface and wait for the exit condition.            */
/* (NOTE: handle ERROR and END-KEY so cleanup code will always fire.    */
MAIN-BLOCK:
DO ON ERROR   UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK
   ON END-KEY UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK:
  RUN enable_UI.
  IF NOT THIS-PROCEDURE:PERSISTENT THEN
    WAIT-FOR CLOSE OF THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

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
  DISPLAY e-formula 
      WITH FRAME DEFAULT-FRAME IN WINDOW C-Win.
  ENABLE e-formula bt-valida BUTTON-7 bt-variaveis BUTTON-3 BUTTON-1 BUTTON-2 
         BUTTON-4 BUTTON-6 BUTTON-5 btOK btCancel btHelp RECT-1 rtToolBar 
      WITH FRAME DEFAULT-FRAME IN WINDOW C-Win.
  {&OPEN-BROWSERS-IN-QUERY-DEFAULT-FRAME}
  VIEW C-Win.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

