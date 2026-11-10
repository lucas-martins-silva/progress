&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          mgfro            PROGRESS
*/
&Scoped-define WINDOW-NAME wWindow


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE TTmab-param NO-UNDO LIKE mab-param
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
{include/i-prgvrs.i AB0116 2.00.00.015}

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i ab0116 MAB}
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
&GLOBAL-DEFINE Program        AB0116
&GLOBAL-DEFINE Version        2.00.00.013

&GLOBAL-DEFINE WindowType     Master

&GLOBAL-DEFINE Folder         YES
&GLOBAL-DEFINE InitialPage    1
&GLOBAL-DEFINE FolderLabels   ParÉmetros


&GLOBAL-DEFINE page0Widgets    btQueryJoins btReportsJoins btExit btHelp 
                              

&GLOBAL-DEFINE page1Widgets   brParam
  
{abp/ab0116.i} /* definiá∆o da temp-table ttParam */
{btb/btb009za.i}
{cdp/cd1002.i}   /** Definicao de variaveis integracao BGC      **/

/******************************************************************************/

/*define buffer bfTTParam for ttParam.*/


/* Local Variable Definitions ---                                       */

DEFINE VARIABLE hDBOParam AS HANDLE     NO-UNDO.
DEFINE VARIABLE cValor AS CHARACTER FORMAT "x(20)"  NO-UNDO.
define VAR lok        as logical no-undo.
DEFINE VARIABLE l-erro-conecta        AS LOGICAL     NO-UNDO.

define buffer b-ttParam for ttParam.
DEFINE VARIABLE c-valor-browse AS CHARACTER FORMAT "x(35)":U NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fpage0
&Scoped-define BROWSE-NAME brParam

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES ttParam

/* Definitions for BROWSE brParam                                       */
&Scoped-define FIELDS-IN-QUERY-brParam ttParam.cdn-param ttParam.des-label-param fnValor(ttParam.des-valor, ttParam.cdn-param) @ c-valor-browse   
&Scoped-define ENABLED-FIELDS-IN-QUERY-brParam   
&Scoped-define SELF-NAME brParam
&Scoped-define QUERY-STRING-brParam FOR EACH ttParam NO-LOCK INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-brParam OPEN QUERY {&SELF-NAME} FOR EACH ttParam NO-LOCK INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-brParam ttParam
&Scoped-define FIRST-TABLE-IN-QUERY-brParam ttParam


/* Definitions for FRAME fPage1                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-fPage1 ~
    ~{&OPEN-QUERY-brParam}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS rtToolBar-2 btQueryJoins btReportsJoins ~
btExit btHelp 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnValor wWindow 
FUNCTION fnValor RETURNS CHARACTER
  ( p-valor     AS CHAR,
    p-cdn-param AS INT )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR wWindow AS WIDGET-HANDLE NO-UNDO.

/* Menu Definitions                                                     */
DEFINE SUB-MENU smFile 
       MENU-ITEM miQueryJoins   LABEL "&Consultas"    
       MENU-ITEM miReportsJoins LABEL "&Relat¢rios"   
       RULE
       MENU-ITEM miExit         LABEL "&Sair"          ACCELERATOR "CTRL-X".

DEFINE SUB-MENU smHelp 
       MENU-ITEM miContents     LABEL "&Conte£do"     
       MENU-ITEM miAbout        LABEL "&Sobre..."     .

DEFINE MENU mbMain MENUBAR
       SUB-MENU  smFile         LABEL "&Arquivo"      
       SUB-MENU  smHelp         LABEL "&Ajuda"        .


/* Definitions of the field level widgets                               */
DEFINE BUTTON btExit 
     IMAGE-UP FILE "image~\im-exi":U
     IMAGE-INSENSITIVE FILE "image~\ii-exi":U
     LABEL "Exit" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE BUTTON btHelp 
     IMAGE-UP FILE "image~\im-hel":U
     IMAGE-INSENSITIVE FILE "image~\ii-hel":U
     LABEL "Help" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE BUTTON btQueryJoins 
     IMAGE-UP FILE "image~\im-joi":U
     IMAGE-INSENSITIVE FILE "image~\ii-joi":U
     LABEL "Query Joins" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE BUTTON btReportsJoins 
     IMAGE-UP FILE "image~\im-pri":U
     IMAGE-INSENSITIVE FILE "image~\ii-pri":U
     LABEL "Reports Joins" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE RECTANGLE rtToolBar-2
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 90 BY 1.5
     BGCOLOR 7 .

DEFINE BUTTON btAltera 
     LABEL "&Alterar" 
     SIZE 10 BY 1.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY brParam FOR 
      ttParam SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE brParam
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS brParam wWindow _FREEFORM
  QUERY brParam DISPLAY
      ttParam.cdn-param LABEL "C¢digo":U WIDTH 08
      ttParam.des-label-param  FORMAT "x(40)" LABEL "Descriá∆o":U  WIDTH 40
      fnValor(ttParam.des-valor, ttParam.cdn-param) @ c-valor-browse FORMAT "x(45)":U LABEL "Valor":U  WIDTH 46
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 82 BY 9.21
         FONT 2.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fpage0
     btQueryJoins AT ROW 1.13 COL 74.72 HELP
          "Consultas relacionadas"
     btReportsJoins AT ROW 1.13 COL 78.72 HELP
          "Relat¢rios relacionados"
     btExit AT ROW 1.13 COL 82.72 HELP
          "Sair"
     btHelp AT ROW 1.13 COL 86.72 HELP
          "Ajuda"
     rtToolBar-2 AT ROW 1 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 90 BY 15.54
         FONT 1.

DEFINE FRAME fPage1
     brParam AT ROW 1 COL 2
     btAltera AT ROW 10.29 COL 2
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.57 ROW 4
         SIZE 84.43 BY 12
         FONT 1.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Window
   Allow: Basic,Browse,DB-Fields,Window,Query
   Add Fields to: Neither
   Temp-Tables and Buffers:
      TABLE: TTmab-param T "?" NO-UNDO mgfro mab-param
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
         TITLE              = ""
         HEIGHT             = 15.5
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

ASSIGN {&WINDOW-NAME}:MENUBAR    = MENU mbMain:HANDLE.
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
/* REPARENT FRAME */
ASSIGN FRAME fPage1:FRAME = FRAME fpage0:HANDLE.

/* SETTINGS FOR FRAME fpage0
   FRAME-NAME                                                           */
/* SETTINGS FOR FRAME fPage1
                                                                        */
/* BROWSE-TAB brParam 1 fPage1 */
ASSIGN 
       brParam:COLUMN-RESIZABLE IN FRAME fPage1       = TRUE
       brParam:COLUMN-MOVABLE IN FRAME fPage1         = TRUE.

IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wWindow)
THEN wWindow:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE brParam
/* Query rebuild information for BROWSE brParam
     _START_FREEFORM
OPEN QUERY {&SELF-NAME} FOR EACH ttParam NO-LOCK INDEXED-REPOSITION.
     _END_FREEFORM
     _Query            is OPENED
*/  /* BROWSE brParam */
&ANALYZE-RESUME

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


&Scoped-define BROWSE-NAME brParam
&Scoped-define FRAME-NAME fPage1
&Scoped-define SELF-NAME brParam
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL brParam wWindow
ON MOUSE-SELECT-DBLCLICK OF brParam IN FRAME fPage1
DO:
    if ttParam.cdn-param:screen-value in browse brParam = "" then 
       apply "choose":U to btAltera in frame fPage1.
    else    
       apply "choose":U to btAltera in frame fPage1.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL brParam wWindow
ON VALUE-CHANGED OF brParam IN FRAME fPage1
DO:
    IF brParam:NUM-SELECTED-ROWS in frame fPage1 > 0 THEN
       enable  btAltera with frame fPage1.
    ELSE disable btAltera with frame fPage1.

    IF ttParam.cdn-param = 15 THEN
        ASSIGN btAltera:SENSITIVE IN FRAME fpage1 = l-execucao-orcamentaria.
        
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btAltera
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btAltera wWindow
ON CHOOSE OF btAltera IN FRAME fPage1 /* Alterar */
DO:
    DEFINE VARIABLE iCdParam AS INTEGER NO-UNDO.
    
    IF brParam:NUM-SELECTED-ROWS > 0 THEN DO ON ERROR UNDO, RETURN NO-APPLY:
      find ttParam where 
           ttParam.cdn-param = int(ttParam.cdn-param:screen-value in browse brParam) no-error.
      IF AVAIL ttParam THEN do:
          ASSIGN iCdParam = ttParam.cdn-param.

           IF  NOT CONNECTED("emsbas") OR 
               NOT CONNECTED("emsfin") OR 
               NOT CONNECTED("emsuni") THEN
               RUN  pi-conecta-ems5(INPUT NO, OUTPUT l-erro-conecta).
           ELSE
               RUN  pi-conecta-ems5(INPUT YES, OUTPUT l-erro-conecta).
          
          /*--- Seta cursor do mouse para espera ---*/
          SESSION:SET-WAIT-STATE("GENERAL":U).
          assign {&window-name}:sensitive = no.

          CASE ttParam.cdn-param:
              WHEN 15 THEN DO:
                  RUN abp/ab0116c.w (INPUT ttParam.cdn-param,
                                     INPUT ttParam.des-label-param, 
                                     INPUT-OUTPUT cValor,
                                     OUTPUT lOK).
              END.
              WHEN 16 THEN DO:
                  RUN abp/ab0116d.w (INPUT ttParam.cdn-param,
                                     INPUT ttParam.des-label-param, 
                                     INPUT-OUTPUT cValor,
                                     OUTPUT lOK).
              END.
              OTHERWISE DO:
                  RUN abp/ab0116b.w (INPUT ttParam.cdn-param,
                                     INPUT ttParam.des-label-param, 
                                     INPUT-OUTPUT cValor,
                                     OUTPUT lOK).
              END.
          END CASE.

          /*--- Seta cursor do mouse para normal ---*/
          SESSION:SET-WAIT-STATE("":U).
          assign {&window-name}:sensitive = yes.

          if lOK then
              run openQueryBrowse in this-procedure.

          find first b-ttParam 
               where b-ttParam.cdn-param = iCdParam no-lock no-error.
          if  avail b-ttParam then do:
              reposition brParam to rowid rowid(b-ttParam).
              
              apply "Entry":U to brParam in FRAME fPage1.
          END.
      END.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fpage0
&Scoped-define SELF-NAME btExit
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btExit wWindow
ON CHOOSE OF btExit IN FRAME fpage0 /* Exit */
OR CHOOSE OF MENU-ITEM miExit IN MENU mbMain DO:
    APPLY "CLOSE":U TO THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btHelp
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btHelp wWindow
ON CHOOSE OF btHelp IN FRAME fpage0 /* Help */
OR CHOOSE OF MENU-ITEM miContents IN MENU mbMain DO:
    {include/ajuda.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btQueryJoins
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btQueryJoins wWindow
ON CHOOSE OF btQueryJoins IN FRAME fpage0 /* Query Joins */
OR CHOOSE OF MENU-ITEM miQueryJoins IN MENU mbMain DO:
    RUN showQueryJoins IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btReportsJoins
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btReportsJoins wWindow
ON CHOOSE OF btReportsJoins IN FRAME fpage0 /* Reports Joins */
OR CHOOSE OF MENU-ITEM miReportsJoins IN MENU mbMain DO:
    RUN showReportsJoins IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wWindow 


/*--- L¢gica para inicializaá∆o do programam ---*/
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
IF VALID-HANDLE(hDBOParam)
    THEN RUN destroy in hDBOParam.

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
IF brParam:NUM-SELECTED-ROWS in frame fPage1 > 0 THEN DO:
    enable  btAltera with frame fPage1.
END.
ELSE DO:
    disable btAltera with frame fPage1.
END.

{utp/ut-liter.i "C¢digo"}
assign ttParam.cdn-param:label in BROWSE brParam = return-value.
{utp/ut-liter.i "Descriá∆o"}
assign ttParam.des-label-param:label in  BROWSE brParam = return-value.
{utp/ut-liter.i "Valor"}
assign c-valor-browse:label in  BROWSE brParam = return-value.

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
IF  NOT CONNECTED("emsbas") OR 
    NOT CONNECTED("emsfin") OR 
    NOT CONNECTED("emsuni") THEN
    RUN  pi-conecta-ems5(INPUT NO, OUTPUT l-erro-conecta).
ELSE
    RUN  pi-conecta-ems5(INPUT YES, OUTPUT l-erro-conecta).

IF NOT VALID-HANDLE(hDBOParam) OR
    hDBOParam:TYPE      <> "PROCEDURE":U OR
    hDBOParam:FILE-NAME <> "frbo/bofr122.p":U THEN DO:
    RUN  frbo/bofr122.p PERSISTENT SET  hDBOParam.
END.

RUN OpenQueryStatic IN hDBOParam (INPUT "Main":U).
RUN getFirst in hDBOParam.
run openQueryBrowse in this-procedure.

RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryBrowse wWindow 
PROCEDURE openQueryBrowse :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
run abp/ab0116a.p (output table ttParam).

/* Validaá∆o para n∆o exibir o Parametro 15 em tela.
   Esse Parametro Ç referente a integraá∆o com Execuá∆o Oráamentaria */
IF l-execucao-orcamentaria = NO THEN DO:
  FIND FIRST ttParam
       WHERE ttParam.cdn-param = 15 EXCLUSIVE-LOCK NO-ERROR.
  IF  AVAIL ttParam THEN DO:
      DELETE ttParam.
  END.
END.

OPEN QUERY brParam FOR EACH ttParam.

IF brParam:NUM-SELECTED-ROWS in frame fPage1 > 0 THEN
    enable  btAltera with frame fPage1.
ELSE 
    DISABLE btAltera with frame fPage1.

RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-conecta-ems5 wWindow 
PROCEDURE pi-conecta-ems5 :
/*------------------------------------------------------------------------------
  Purpose:     pi-conecta-ems5
  Parameters:  Entrada l-conecta = Sim - Conecta Bancos
                                   N∆o - Desconecta Bancos
               Sa°da   i-erro-conecta = Se ocorreram erros de conex∆o
  Notes:       Conecta bancos do EMS5
------------------------------------------------------------------------------*/
DEFINE INPUT  PARAMETER l-conecta      as logical no-undo.
DEFINE OUTPUT PARAMETER l-erro-conecta as logical no-undo init no.
DEF VAR h-btb009za AS HANDLE NO-UNDO.
DEF VAR l-conectado AS LOGICAL NO-UNDO.

RUN btb/btb009za.p PERSISTENT SET h-btb009za.

for first param-global no-lock:
end.

if not avail param-global then do:
    /** ParÉmetros Globais n∆o Cadastrados **/
    run piCriaErro (input 16, 
                    input 'EMS':U, 
                    input "":U).

    assign l-erro-conecta = yes.

    return "NOK":U.
end.

/** Solicitaá∆o para Conectar bancos do Financeiro **/
if l-conecta then do:
    /** Verifica se bancos do Financeiro n∆o est∆o conectados **/
    if  not connected("emsbas") or 
        not connected("emsfin") or 
        not connected("emsuni") then do:
    /*    assign l-conectado = no.*/
/*         if  search("prgint/dcf/dcf903za.r")  = ? and       */
/*             search("prgint/dcf/dcf903za.py") = ? then do:  */
/*             /** Erro **/                                   */
/*             run piCriaErro (4, 'EMS':U, "dcf900za":U).     */
/*             assign l-erro-conecta = yes.                   */
/*         end.                                               */
/*         if  search("prgfin/acr/acr711zf.r ")  = ? and      */
/*             search("prgfin/acr/acr711zf.py ") = ? then do: */
/*             /** Erro **/                                   */
/*             run piCriaErro (4, 'EMS':U, "acr711zf":U).     */
/*             assign l-erro-conecta = yes.                   */
/*         end.                                               */
       /* else do:*/
            run pi-conecta-bco IN h-btb009za (Input 1,                          /*versao api */
                                              Input 1,                          /* 1 - conex∆o, 2 - desconex∆o */
                                              Input param-global.empresa-prin,  /* cod empresa*/
                                              Input "all", 
                                              Output Table tt_erros_conexao).

            if return-value <> "OK":U then do:
                FOR EACH tt_erros_conexao no-lock:
                    /** Erro **/
                    run piCriaErro (INPUT tt_erros_conexao.cd-erro, 
                                    INPUT 'EMS':U, 
                                    INPUT tt_erros_conexao.param-1).
                    assign l-erro-conecta = yes.
                end.
           /* end.*/
        end.
    END.
    else do:
        assign l-conectado = yes.
    end.
end.
/** Solicitaá∆o para Desconectar bancos do Financeiro **/
if not l-conecta or l-erro-conecta then do:
    if not l-conectado then do:
        if  connected("emsbas") or 
            connected("emsfin") or 
            connected("emsuni") then do:
            run pi-conecta-bco IN h-btb009za (Input 1,          /*versao api */
                                              Input 2,          /* 1 - conex∆o, 2 - desconex∆o */
                                              Input param-global.empresa-prin,  /* cod empresa*/
                                              Input "all", 
                                              Output Table tt_erros_conexao).

            if return-value <> "OK":U then do:
                FOR EACH tt_erros_conexao no-lock:
                    /** Erro **/
                    run piCriaErro (INPUT tt_erros_conexao.cd-erro,
                                    INPUT 'EMS':U,
                                    INPUT tt_erros_conexao.param-1).
                    assign l-erro-conecta = yes.
                end.
            end.
        end.
    end.
end.

IF VALID-HANDLE(h-btb009za) THEN
   DELETE PROCEDURE h-btb009za.

RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fnValor wWindow 
FUNCTION fnValor RETURNS CHARACTER
  ( p-valor     AS CHAR,
    p-cdn-param AS INT ) :
/*------------------------------------------------------------------------------
  Purpose:  retorna o valor ao browse.
    Notes:  fnValor(ttParam.des-valor, ttParam.cdn-param) @ c-valor-browse FORMAT "x(35)":U LABEL "Valor":U  WIDTH 30
------------------------------------------------------------------------------*/
DEFINE VARIABLE c-retorno AS CHARACTER FORMAT "X(35)":U NO-UNDO.

CASE p-cdn-param:
    WHEN 2 OR WHEN 4 OR WHEN 5 OR WHEN 6 OR WHEN 7 OR WHEN 11 OR WHEN 14 THEN DO:
        {utp/ut-liter.i Sim/N∆o *}
        ASSIGN c-retorno = ENTRY (INT(TRIM(substring(p-valor,1,1))), trim(RETURN-VALUE) , "/":U ).
    END.
    WHEN 3 THEN DO:
        IF p-valor = "1" THEN DO:
            {utp/ut-liter.i "Matr°cula"}
            ASSIGN c-retorno = RETURN-VALUE.
        END.
        ELSE DO:
            {utp/ut-liter.i "C¢digo de Pessoa F°sica"}
            ASSIGN c-retorno = RETURN-VALUE.
        END.
    END.
    WHEN 8 THEN DO:
        IF p-valor = "1" THEN DO:
            {utp/ut-liter.i "N∆o_integra_com_sistema"}
            ASSIGN c-retorno = RETURN-VALUE.
        END.
        ELSE IF p-valor = "2" THEN DO:
            {utp/ut-liter.i "Integra_ON-LINE"}
            ASSIGN c-retorno = RETURN-VALUE.
        END.
        ELSE IF p-valor = "3" THEN DO:
            {utp/ut-liter.i "Integra_Batch"}
            ASSIGN c-retorno = RETURN-VALUE.
        END.
    END.
    when 9 then do:
        IF p-valor = "1" THEN DO:
            {utp/ut-liter.i "N∆o_Permite"}
            ASSIGN c-retorno = RETURN-VALUE.
        END.
        ELSE IF p-valor = "2" THEN DO:
            {utp/ut-liter.i "Pergunta"}
            ASSIGN c-retorno = RETURN-VALUE.
        END.
        ELSE IF p-valor = "3" THEN DO:
            {utp/ut-liter.i "Permite"}
            ASSIGN c-retorno = RETURN-VALUE.
        end.
    end.
    when 10 then do:
        assign c-retorno = substring(p-valor,1,15).
    end.
    when 13 then do:
        IF ENTRY(1,p-valor) = "1" THEN DO:
            {utp/ut-liter.i "Com_Unidade_de_Neg¢cio"}
            ASSIGN c-retorno = RETURN-VALUE.
        END.
        ELSE DO:
            {utp/ut-liter.i "Sem_Unidade_de_Neg¢cio"}
            ASSIGN c-retorno = RETURN-VALUE.
        END.
    end.
    OTHERWISE DO:
        ASSIGN c-retorno = p-valor.
    END.
END CASE.

RETURN c-retorno.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

