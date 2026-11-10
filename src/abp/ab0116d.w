&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
*/
&Scoped-define WINDOW-NAME wWindow


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE tt-mab-param-integr NO-UNDO LIKE mab-param-integr
       field r-rowid as rowid.



&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS wWindow 
/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i AB0116D 2.00.00.003}

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i ab0116d MAB}
&ENDIF

CREATE WIDGET-POOL.

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program        AB0116D
&GLOBAL-DEFINE Version        2.00.00.003

&GLOBAL-DEFINE WindowType     Detail

&GLOBAL-DEFINE page0Widgets   cParam cDescParam ~
                              cText ~
                              tg-valor-padrao ~
                              fi-di-cc-om f-campo ~
                              fi-di-cc-solicitante f-campo-1 ~
                              fi-di-cc-desp-om f-campo-2 ~
                              fi-di-cc-equipto f-campo-3 ~
                              btOK btCancel btHelp2


/* Parameters Definitions ---                                           */
define input parameter  pParam        LIKE mab-param-integr.cdn-param.
define input parameter  pDescParam    LIKE mab-param-integr.des-label-param.
define input-output parameter pValor  AS CHAR FORMAT "x(50)" NO-UNDO.
define output parameter l-ok          as logical. 

define variable hDBOParam             as handle              no-undo.
                                      
define VAR pValor1                    AS CHAR FORMAT "x(50)" NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fpage0

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS RECT-1 RECT-2 rtToolBar RECT-73 cParam ~
cDescParam fi-di-cc-om tg-valor-padrao fi-di-cc-solicitante ~
fi-di-cc-desp-om fi-di-cc-equipto cText btOK btCancel btHelp2 f-campo ~
f-campo-1 f-campo-2 f-campo-3 
&Scoped-Define DISPLAYED-OBJECTS cParam cDescParam fi-di-cc-om ~
tg-valor-padrao fi-di-cc-solicitante fi-di-cc-desp-om fi-di-cc-equipto ~
cText f-campo f-campo-1 f-campo-2 f-campo-3 

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

DEFINE VARIABLE cText AS CHARACTER 
     VIEW-AS EDITOR MAX-CHARS 200 SCROLLBAR-VERTICAL
     SIZE 58 BY 4
     BGCOLOR 15 FGCOLOR 0  NO-UNDO.

DEFINE VARIABLE cDescParam AS CHARACTER FORMAT "X(40)":U 
     VIEW-AS FILL-IN 
     SIZE 40 BY .88 NO-UNDO.

DEFINE VARIABLE cParam AS CHARACTER FORMAT "X(8)":U 
     LABEL "C¢digo" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88 NO-UNDO.

DEFINE VARIABLE f-campo AS CHARACTER FORMAT "X(256)":U INITIAL "Centro de Custo da Conta da OM" 
      VIEW-AS TEXT 
     SIZE 36.43 BY .67 NO-UNDO.

DEFINE VARIABLE f-campo-1 AS CHARACTER FORMAT "X(256)":U INITIAL "Centro de Custo do Solicitante" 
      VIEW-AS TEXT 
     SIZE 36.43 BY .67 NO-UNDO.

DEFINE VARIABLE f-campo-2 AS CHARACTER FORMAT "X(256)":U INITIAL "Centro de Custo da Conta de Despesa da OM" 
      VIEW-AS TEXT 
     SIZE 35.43 BY .67 NO-UNDO.

DEFINE VARIABLE f-campo-3 AS CHARACTER FORMAT "X(256)":U INITIAL "Centro de Custo do Equipamento" 
      VIEW-AS TEXT 
     SIZE 37.43 BY .67 NO-UNDO.

DEFINE VARIABLE fi-di-cc-desp-om AS INTEGER FORMAT "9":U INITIAL 3 
     VIEW-AS FILL-IN 
     SIZE 3 BY .79 NO-UNDO.

DEFINE VARIABLE fi-di-cc-equipto AS INTEGER FORMAT "9":U INITIAL 4 
     VIEW-AS FILL-IN 
     SIZE 3 BY .79 NO-UNDO.

DEFINE VARIABLE fi-di-cc-om AS INTEGER FORMAT "9":U INITIAL 1 
     VIEW-AS FILL-IN 
     SIZE 3 BY .79 NO-UNDO.

DEFINE VARIABLE fi-di-cc-solicitante AS INTEGER FORMAT "9":U INITIAL 2 
     VIEW-AS FILL-IN 
     SIZE 3 BY .79 NO-UNDO.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 60.57 BY 11.25.

DEFINE RECTANGLE RECT-2
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 58.72 BY 1.38.

DEFINE RECTANGLE RECT-73
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 59 BY 4.63.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 61 BY 1.42
     BGCOLOR 7 .

DEFINE VARIABLE tg-valor-padrao AS LOGICAL INITIAL no 
     LABEL "Valor PadrÆo" 
     VIEW-AS TOGGLE-BOX
     SIZE 13 BY .83 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fpage0
     cParam AT ROW 1.58 COL 7.57 COLON-ALIGNED WIDGET-ID 68
     cDescParam AT ROW 1.58 COL 17.57 COLON-ALIGNED NO-LABEL WIDGET-ID 66
     fi-di-cc-om AT ROW 3.96 COL 1.57 COLON-ALIGNED NO-LABEL WIDGET-ID 80
     tg-valor-padrao AT ROW 3.96 COL 45.43 WIDGET-ID 34
     fi-di-cc-solicitante AT ROW 4.83 COL 1.57 COLON-ALIGNED NO-LABEL WIDGET-ID 82
     fi-di-cc-desp-om AT ROW 5.71 COL 1.57 COLON-ALIGNED NO-LABEL WIDGET-ID 22
     fi-di-cc-equipto AT ROW 6.63 COL 1.57 COLON-ALIGNED NO-LABEL WIDGET-ID 78
     cText AT ROW 8.29 COL 2.43 NO-LABEL WIDGET-ID 70
     btOK AT ROW 12.83 COL 2
     btCancel AT ROW 12.83 COL 13.14
     btHelp2 AT ROW 12.83 COL 50.72
     f-campo AT ROW 4.04 COL 7.57 NO-LABEL WIDGET-ID 72
     f-campo-1 AT ROW 4.92 COL 7.57 NO-LABEL WIDGET-ID 74
     f-campo-2 AT ROW 5.75 COL 7.57 NO-LABEL WIDGET-ID 16
     f-campo-3 AT ROW 6.67 COL 7.57 NO-LABEL WIDGET-ID 30
     "Crit‚rio Centro Custo" VIEW-AS TEXT
          SIZE 15 BY .54 AT ROW 3.08 COL 3 WIDGET-ID 76
     RECT-1 AT ROW 1.25 COL 1.43
     RECT-2 AT ROW 1.38 COL 2.29
     rtToolBar AT ROW 12.63 COL 1
     RECT-73 AT ROW 3.38 COL 2 WIDGET-ID 26
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 61.43 BY 13.25
         FONT 1.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Window
   Allow: Basic,Browse,DB-Fields,Window,Query
   Add Fields to: Neither
   Temp-Tables and Buffers:
      TABLE: tt-mab-param-integr T "?" NO-UNDO mgmnt mab-param-integr
      ADDITIONAL-FIELDS:
          field r-rowid as rowid
      END-FIELDS.
   END-TABLES.
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW wWindow ASSIGN
         HIDDEN             = YES
         TITLE              = "Parƒmetros"
         HEIGHT             = 13.29
         WIDTH              = 61.72
         MAX-HEIGHT         = 28.21
         MAX-WIDTH          = 146.29
         VIRTUAL-HEIGHT     = 28.21
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
/* SETTINGS FOR FRAME fpage0
   FRAME-NAME                                                           */
/* SETTINGS FOR FILL-IN f-campo IN FRAME fpage0
   ALIGN-L                                                              */
/* SETTINGS FOR FILL-IN f-campo-1 IN FRAME fpage0
   ALIGN-L                                                              */
/* SETTINGS FOR FILL-IN f-campo-2 IN FRAME fpage0
   ALIGN-L                                                              */
/* SETTINGS FOR FILL-IN f-campo-3 IN FRAME fpage0
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

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME wWindow
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wWindow wWindow
ON END-ERROR OF wWindow /* Parƒmetros */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wWindow wWindow
ON WINDOW-CLOSE OF wWindow /* Parƒmetros */
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
    ASSIGN l-ok    = YES
           pValor1 = "":U.

    EMPTY TEMP-TABLE rowErrors.
    RUN emptyRowErrors IN hDBOParam.

    APPLY 'value-Changed':U TO fi-di-cc-om          IN FRAME {&FRAME-NAME}.
    APPLY 'value-Changed':U TO fi-di-cc-solicitante IN FRAME {&FRAME-NAME}.
    APPLY 'value-Changed':U TO fi-di-cc-desp-om     IN FRAME {&FRAME-NAME}.
    APPLY 'value-Changed':U TO fi-di-cc-equipto     IN FRAME {&FRAME-NAME}.

    ASSIGN pValor1 = STRING(fi-di-cc-om) + "," + STRING(fi-di-cc-solicitante) + "," + STRING(fi-di-cc-desp-om) + "," + STRING(fi-di-cc-equipto).
    RUN atualizaValor1 IN hDBOParam (INPUT pParam,
                                     INPUT cDescParam:SCREEN-VALUE IN FRAME fPage0,
                                     INPUT cText:SCREEN-VALUE IN FRAME fPage0,         
                                     INPUT-OUTPUT pValor1).

    IF  RETURN-VALUE = "NOK":U THEN DO:
        RUN getRowErrors IN hDBOParam (OUTPUT TABLE RowErrors APPEND).
        RUN piMostraErros IN THIS-PROCEDURE.
        RETURN NO-APPLY.
    END.

    APPLY "CLOSE":U TO THIS-PROCEDURE.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fi-di-cc-desp-om
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-di-cc-desp-om wWindow
ON VALUE-CHANGED OF fi-di-cc-desp-om IN FRAME fpage0
DO:
    ASSIGN fi-di-cc-desp-om = INTEGER(fi-di-cc-desp-om:SCREEN-VALUE IN FRAME fPage0).
    IF  fi-di-cc-desp-om <> 3 THEN
        ASSIGN tg-valor-padrao:CHECKED IN FRAME fPage0 = FALSE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fi-di-cc-equipto
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-di-cc-equipto wWindow
ON VALUE-CHANGED OF fi-di-cc-equipto IN FRAME fpage0
DO:
    ASSIGN fi-di-cc-equipto = INTEGER(fi-di-cc-equipto:SCREEN-VALUE IN FRAME fPage0).
    IF  fi-di-cc-equipto <> 4 THEN
        ASSIGN tg-valor-padrao:CHECKED IN FRAME fPage0 = FALSE.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fi-di-cc-om
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-di-cc-om wWindow
ON VALUE-CHANGED OF fi-di-cc-om IN FRAME fpage0
DO:
  ASSIGN fi-di-cc-om = INTEGER(fi-di-cc-om:SCREEN-VALUE IN FRAME fPage0).
  IF  fi-di-cc-om <> 1 THEN
      ASSIGN tg-valor-padrao:CHECKED IN FRAME fPage0 = FALSE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fi-di-cc-solicitante
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-di-cc-solicitante wWindow
ON VALUE-CHANGED OF fi-di-cc-solicitante IN FRAME fpage0
DO:
    ASSIGN fi-di-cc-solicitante = INTEGER(fi-di-cc-solicitante:SCREEN-VALUE IN FRAME fPage0).
    IF  fi-di-cc-solicitante <> 2 THEN
        ASSIGN tg-valor-padrao:CHECKED IN FRAME fPage0 = FALSE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tg-valor-padrao
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tg-valor-padrao wWindow
ON VALUE-CHANGED OF tg-valor-padrao IN FRAME fpage0 /* Valor PadrÆo */
DO:
    ASSIGN fi-di-cc-om:SCREEN-VALUE IN FRAME fPage0          = "1"
           fi-di-cc-solicitante:SCREEN-VALUE IN FRAME fPage0 = "2"
           fi-di-cc-desp-om:SCREEN-VALUE IN FRAME fPage0     = "3"
           fi-di-cc-equipto:SCREEN-VALUE IN FRAME fPage0     = "4".
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wWindow 


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
    
    if  valid-handle(hDBOParam) then
        delete procedure hDBOParam.
    
    {method/showmessage.i3}
    
    return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterDisplayFields wWindow 
PROCEDURE afterDisplayFields :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DISPLAY cParam
            cDescParam with frame fPage0.
    
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
    FOR FIRST mab-param-integr FIELDS (cdn-param des-label-param des-param des-valor)
        WHERE mab-param-integr.cdn-param = pParam NO-LOCK:
    END. 
    
    ASSIGN cParam    :SENSITIVE    IN FRAME fPage0 = NO
           cDescParam:SENSITIVE    IN FRAME fPage0 = NO
           cText     :SENSITIVE    IN FRAME fPage0 = NO
           cParam    :SCREEN-VALUE IN FRAME fPage0 = STRING(mab-param-integr.cdn-param).
    
    /*Parametro que usa Toogle-Box*/
    IF  mab-param-integr.cdn-param = 16 THEN DO:
        ASSIGN fi-di-cc-om:SCREEN-VALUE IN FRAME fPage0          = SUBSTRING(mab-param-integr.des-valor,1,1)
               fi-di-cc-solicitante:SCREEN-VALUE IN FRAME fPage0 = SUBSTRING(mab-param-integr.des-valor,3,1)
               fi-di-cc-desp-om:SCREEN-VALUE IN FRAME fPage0     = SUBSTRING(mab-param-integr.des-valor,5,1)
               fi-di-cc-equipto:SCREEN-VALUE IN FRAME fPage0     = SUBSTRING(mab-param-integr.des-valor,7,1).
        IF  mab-param-integr.des-valor = "1,2,3,4" THEN
            ASSIGN tg-valor-padrao:CHECKED IN FRAME fPage0 = TRUE.
    END.
    
    RUN utp/ut-liter.p (mab-param-integr.des-label-param, "*", "").
    ASSIGN cDescParam:SCREEN-VALUE IN FRAME fPage0 = RETURN-VALUE.

    RUN utp/ut-liter.p (mab-param-integr.des-param, "*", "").
    ASSIGN cText:SCREEN-VALUE IN FRAME fPage0 = RETURN-VALUE.

    FOR FIRST funcao
        WHERE funcao.cd-funcao = "Integra_MLA_EMS":U
        AND   funcao.ativo     = NO NO-LOCK:
        ASSIGN fi-di-cc-om:SENSITIVE IN FRAME fPage0          = NO
               fi-di-cc-solicitante:SENSITIVE IN FRAME fPage0 = NO
               fi-di-cc-desp-om:SENSITIVE IN FRAME fPage0     = NO
               fi-di-cc-equipto:SENSITIVE IN FRAME fPage0     = NO
               tg-valor-padrao:SENSITIVE IN FRAME fPage0      = NO.
    END.
    
    APPLY "VALUE-CHANGED":U TO THIS-PROCEDURE.
    
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
    IF NOT VALID-HANDLE(hDBOParam)           OR
        hDBOParam:TYPE      <> "PROCEDURE":U OR
        hDBOParam:FILE-NAME <> "frbo/bofr122.p":U THEN DO:
        run frbo/bofr122.p persistent set  hDBOParam.
    END.
    
    RUN OpenQueryStatic IN hDBOParam (INPUT "Main":U) NO-ERROR.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piMostraErros wWindow 
PROCEDURE piMostraErros :
/*------------------------------------------------------------------------------  
  Purpose:     piMostraErros
  Parameters:  <none>
  Notes:       Verifica a temp-table de erros da BO e mostra em tela as mensagens
------------------------------------------------------------------------------*/
    /** Instancia aplicativo **/
    {method/showmessage.i1}
    /** Busca erros na BO **/
    run getRowErrors in hDBOParam (output table RowErrors).
    /** Mostra caixa com erros **/
    {method/showmessage.i2 &Modal="YES"}
    /** Limpa temp-tables de erros **/
    run emptyRowErrors in hDBOParam.
    
    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

