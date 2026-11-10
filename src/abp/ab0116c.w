&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
*/
&Scoped-define WINDOW-NAME wWindow


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE tt-mi-param-extens NO-UNDO LIKE mi-param-extens
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
{include/i-prgvrs.i AB0116C 2.00.00.003}
{cdp/cdcfgmnt.i} /* Versäes EMS MNT */

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i ab0116c MAB}
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
&GLOBAL-DEFINE Program        AB0116C
&GLOBAL-DEFINE Version        2.00.00.001

&GLOBAL-DEFINE WindowType     Detail

&GLOBAL-DEFINE page0Widgets   cParam cDescParam cText ~
                              btOK btCancel btHelp2  

/* Parameters Definitions ---                                           */
define input parameter  pParam        LIKE mab-param.cdn-param.
define input parameter  pDescParam    LIKE mab-param.des-label-param.
define input-output parameter pValor  AS CHAR FORMAT "x(50)" NO-UNDO.
define output parameter l-ok          as logical. 

define variable hDBOParam             as handle              no-undo.
                                      
define VAR pValor1                    AS CHAR FORMAT "x(50)" NO-UNDO.
DEFINE VAR lValorAlterado             AS LOGICAL             NO-UNDO.
define VAR cLiterSim                  AS CHAR                NO-UNDO.
define VAR cLiterNao                  AS CHAR                NO-UNDO.

{cdp/cd1002.i}   /** Definicao de variaveis integracao BGC      **/

/******************************************************************************/

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fpage0

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS RECT-1 RECT-2 rtToolBar RECT-3 RECT-4 RECT-5 ~
RECT-6 cParam cDescParam tgReqDev-mab tgReqDev-mpn tgMateriais-mmv ~
tgMOB-mmv tgGGF-mmv cText btOK btCancel btHelp2 
&Scoped-Define DISPLAYED-OBJECTS cParam cDescParam tgReqDev-mab ~
tgReqDev-mpn tgMateriais-mmv tgMOB-mmv tgGGF-mmv cText 

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
     VIEW-AS EDITOR MAX-CHARS 100 SCROLLBAR-VERTICAL
     SIZE 87.57 BY 4
     BGCOLOR 15 FGCOLOR 0  NO-UNDO.

DEFINE VARIABLE cDescParam AS CHARACTER FORMAT "X(35)":U 
     VIEW-AS FILL-IN 
     SIZE 65 BY .88 NO-UNDO.

DEFINE VARIABLE cParam AS CHARACTER FORMAT "X(8)":U 
     LABEL "C¢digo" 
     VIEW-AS FILL-IN 
     SIZE 13.43 BY .88 NO-UNDO.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 89.57 BY 10.25.

DEFINE RECTANGLE RECT-2
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 88 BY 1.38.

DEFINE RECTANGLE RECT-3
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 89.57 BY 9.75.

DEFINE RECTANGLE RECT-4
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 28.72 BY 2.88.

DEFINE RECTANGLE RECT-5
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 28.72 BY 2.88.

DEFINE RECTANGLE RECT-6
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 28.72 BY 2.88.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 89.57 BY 1.42
     BGCOLOR 7 .

DEFINE VARIABLE tgGGF-mmv AS LOGICAL INITIAL no 
     LABEL "Gastos Gerais de Fabrica‡Æo (GGF)" 
     VIEW-AS TOGGLE-BOX
     SIZE 27.14 BY .83 NO-UNDO.

DEFINE VARIABLE tgMateriais-mmv AS LOGICAL INITIAL no 
     LABEL "Materiais" 
     VIEW-AS TOGGLE-BOX
     SIZE 11.57 BY .83 NO-UNDO.

DEFINE VARIABLE tgMOB-mmv AS LOGICAL INITIAL no 
     LABEL "MÆo de Obra (MOB)" 
     VIEW-AS TOGGLE-BOX
     SIZE 19.43 BY .83 NO-UNDO.

DEFINE VARIABLE tgReqDev-mab AS LOGICAL INITIAL no 
     LABEL "Requisi‡Æo/Devolu‡Æo Estoque" 
     VIEW-AS TOGGLE-BOX
     SIZE 27.14 BY .83 NO-UNDO.

DEFINE VARIABLE tgReqDev-mpn AS LOGICAL INITIAL no 
     LABEL "Requisi‡Æo/Devolu‡Æo Estoque" 
     VIEW-AS TOGGLE-BOX
     SIZE 27.14 BY .83 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fpage0
     cParam AT ROW 1.58 COL 7.57 COLON-ALIGNED
     cDescParam AT ROW 1.58 COL 21 COLON-ALIGNED NO-LABEL
     tgReqDev-mab AT ROW 3.71 COL 32.43 WIDGET-ID 24
     tgReqDev-mpn AT ROW 3.71 COL 62.43 WIDGET-ID 32
     tgMateriais-mmv AT ROW 3.79 COL 2.86 WIDGET-ID 64
     tgMOB-mmv AT ROW 4.54 COL 2.86 WIDGET-ID 18
     tgGGF-mmv AT ROW 5.29 COL 2.86 WIDGET-ID 14
     cText AT ROW 6.58 COL 2.43 NO-LABEL
     btOK AT ROW 11.96 COL 2
     btCancel AT ROW 11.96 COL 13.14
     btHelp2 AT ROW 11.96 COL 80.14
     "Manuten‡Æo Veicular" VIEW-AS TEXT
          SIZE 8 BY .54 AT ROW 3 COL 4 WIDGET-ID 4
     "Manuten‡Æo Mecƒnica" VIEW-AS TEXT
          SIZE 17.14 BY .54 AT ROW 3.08 COL 3.86 WIDGET-ID 12
     "Pneus" VIEW-AS TEXT
          SIZE 5.57 BY .54 AT ROW 3 COL 63.43 WIDGET-ID 28
     "Abastecimento e Lubrifica‡Æo" VIEW-AS TEXT
          SIZE 20.57 BY .54 AT ROW 3 COL 33.43 WIDGET-ID 20
     RECT-1 AT ROW 1.25 COL 1.43
     RECT-2 AT ROW 1.38 COL 2.29
     rtToolBar AT ROW 11.75 COL 1
     RECT-3 AT ROW 1.25 COL 1.43 WIDGET-ID 8
     RECT-4 AT ROW 3.38 COL 61.57 WIDGET-ID 54
     RECT-5 AT ROW 3.38 COL 31.72 WIDGET-ID 56
     RECT-6 AT ROW 3.38 COL 2.29 WIDGET-ID 58
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 90.43 BY 12.5
         FONT 1.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Window
   Allow: Basic,Browse,DB-Fields,Window,Query
   Add Fields to: Neither
   Temp-Tables and Buffers:
      TABLE: tt-mi-param-extens T "?" NO-UNDO mgmnt mi-param-extens
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
         HEIGHT             = 12.54
         WIDTH              = 90.43
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
    {method/showmessage.i1}
    
    ASSIGN l-ok    = yes
           pValor1 = "":U.

    /** Verifica se est  ativa a fun‡Æo Execu‡Æo Or‡ament ria  **/
    IF l-execucao-orcamentaria THEN DO:
        CASE mab-param-integr.cdn-param:
            WHEN 15 THEN DO: 
                {utp/ut-liter.i Sim }
                ASSIGN cLiterSim = RETURN-VALUE.
                {utp/ut-liter.i NÆo }
                ASSIGN cLiterNao = RETURN-VALUE.
                
                RUN piValor(INPUT "":U,  INPUT tgMateriais-mmv:CHECKED IN FRAME fPage0).
                RUN piValor(INPUT ",":U, INPUT tgMOB-mmv:CHECKED IN FRAME fPage0).
                RUN piValor(INPUT ",":U, INPUT tgGGF-mmv:CHECKED IN FRAME fPage0).
                RUN piValor(INPUT ",":U, INPUT tgReqDev-mab:CHECKED IN FRAME fPage0).
                RUN piValor(INPUT ",":U, INPUT tgReqDev-mpn:CHECKED IN FRAME fPage0).
            END.
        END CASE.
    END.
    
    RUN atualizaValor1 IN hDBOParam   (INPUT pParam,
                                       INPUT cDescParam:screen-value in frame fPage0,
                                       INPUT cText:screen-value in frame fPage0,
                                       INPUT-OUTPUT pValor1).

    IF  RETURN-VALUE = "NOK":U THEN DO:
        RUN piMostraErros IN THIS-PROCEDURE.
        
        RETURN NO-APPLY.
    END.
    ELSE DO:
        IF  pValor1 = "1" THEN
            ASSIGN lValorAlterado = YES.
        ELSE
            ASSIGN lValorAlterado = NO.           
    END.

    APPLY "CLOSE":U TO THIS-PROCEDURE.
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
define variable cAux as character  no-undo.

assign cText:sensitive in frame fPage0 = YES
       cText:read-only in frame fPage0 = NO.

FOR FIRST mab-param-integr FIELDS(cdn-param des-label-param des-param des-valor)
    WHERE mab-param-integr.cdn-param = pParam NO-LOCK:

    ASSIGN cParam:SCREEN-VALUE IN FRAME fPage0     = string(mab-param-integr.cdn-param)
           cDescParam:SCREEN-VALUE IN FRAME fPage0 = mab-param-integr.des-label-param
           cText:SCREEN-VALUE IN FRAME fPage0      = mab-param-integr.des-param no-error.

    /** Verifica se est  ativa a fun‡Æo Execu‡Æo Or‡ament ria  **/
    IF l-execucao-orcamentaria THEN DO:
        CASE mab-param-integr.cdn-param:
             WHEN 15 THEN DO:  

                  ASSIGN tgMateriais-mmv:SENSITIVE IN FRAME fPage0 = YES
                         tgMOB-mmv:SENSITIVE IN FRAME       fPage0 = YES
                         tgGGF-mmv:SENSITIVE IN FRAME       fPage0 = YES
                         tgReqDev-mab:SENSITIVE IN FRAME fPage0 = YES
                         tgReqDev-mpn:SENSITIVE IN FRAME fPage0 = YES.
                   
                   if num-entries(mab-param-integr.des-valor) > 0 then do:
                        {utp/ut-liter.i Sim *}
                        assign cAux = trim(return-value).

                        assign tgMateriais-mmv:checked in frame fPage0 = (entry(1,mab-param-integr.des-valor)  = cAux)
                               tgMOB-mmv:checked in frame fPage0       = (entry(2,mab-param-integr.des-valor)  = cAux)
                               tgGGF-mmv:checked in frame fPage0       = (entry(3,mab-param-integr.des-valor)  = cAux)
                               tgReqDev-mab:checked in frame fPage0    = (entry(4,mab-param-integr.des-valor)  = cAux)
                               tgReqDev-mpn:checked in frame fPage0    = (entry(5,mab-param-integr.des-valor)  = cAux).
                                                                              
                   END. /* num-entries*/                                             
               END. /* when 15 */
        END CASE.
    END. /* l-execucao-orcamentaria */
END. /*for first mab-param-integr*/

disable cParam with frame fPage0.
enable cDescParam
       cText with frame fPage0.
assign cParam:sensitive in frame     fPage0 = NO
       cDescParam:sensitive in frame fPage0 = YES.

return "OK":U.

end procedure.

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

return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piValor wWindow 
PROCEDURE piValor :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER pSeparador AS CHARACTER NO-UNDO.
DEFINE INPUT PARAMETER lChecked   AS LOGICAL NO-UNDO.

IF lChecked = YES THEN
    ASSIGN pValor1 = pValor1 + pSeparador + cLiterSim.
ELSE 
    ASSIGN pValor1 = pValor1 + pSeparador + cLiterNao.  
  
RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

