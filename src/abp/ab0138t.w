&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          ems2cad          PROGRESS
*/
&Scoped-define WINDOW-NAME wWindow
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS wWindow 
/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i AB0138T 2.00.00.001}  /*** 010001 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i ab0138t MAB}
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
&GLOBAL-DEFINE Program        AB0138T
&GLOBAL-DEFINE Version        2.00.00.001

&GLOBAL-DEFINE WindowType     Detail

&GLOBAL-DEFINE Folder         NO
&GLOBAL-DEFINE InitialPage    0
&GLOBAL-DEFINE FolderLabels   

&GLOBAL-DEFINE page0Widgets   btOK btCancel btHelp2 fi-ep-codigo fi-cod-eqpto fi-eqpto-descricao              ~
                              fi-dat-situacao fi-hra-situacao fi-cod-servico-pneu fi-des-servico-pneu         ~
                              fi-cd-causa-pneu fi-des-causa-pneu fi-cod-sit-eqpto-pneu fi-des-sit-eqpto-pneu  ~
                              tgEntraMedia fi-cd-causa-compon fi-des-sit-eqpto-compon fi-cod-sit-eqpto-compon ~
                              fi-des-sit-eqpto-compon btConsultaPneu btConsultaCompon
&GLOBAL-DEFINE page1Widgets   
&GLOBAL-DEFINE page2Widgets   

/* Parameters Definitions ---                                           */
define input  parameter p-ep-codigo           like mab-eqpto.ep-codigo    no-undo.
define input  parameter p-cod-eqpto           like mab-eqpto.cod-eqpto    no-undo.
define input  parameter p-dat-situacao        like mab-eqpto.dat-situacao no-undo.
define input  parameter p-hra-situacao        like mab-eqpto.hra-situacao no-undo.
define output parameter p-cod-servico-pneu    as character                no-undo.
define output parameter p-cd-causa-pneu       as character                no-undo.
define output parameter p-cod-situacao-pneu   as character                no-undo.
define output parameter p-cd-causa-compon     as character                no-undo.
define output parameter p-cod-situacao-compon as character                no-undo.
define output parameter p-entra-media         as logical                  no-undo.

/* Local Variable Definitions ---                                       */
/*DEFINE VARIABLE hDBOServico AS HANDLE     NO-UNDO.
DEFINE VARIABLE hDBOCausa   AS HANDLE     NO-UNDO.
DEFINE VARIABLE hDBOSit     AS HANDLE     NO-UNDO.*/
DEFINE VARIABLE hDBOEquipto     AS HANDLE     NO-UNDO.
DEFINE VARIABLE hDBOMovtoPneu   AS HANDLE     NO-UNDO.
DEFINE VARIABLE hDBOMovtoCompon AS HANDLE     NO-UNDO.

define temp-table tt-mpn-movto-pneu   no-undo like mpn-movto-pneu
    field r-rowid as rowid.

define temp-table tt-mco-movto-compon no-undo like mco-movto-compon
    field r-rowid as rowid.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fpage0

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS fi-ep-codigo fi-cod-eqpto fi-eqpto-descricao ~
fi-dat-situacao fi-hra-situacao fi-cod-servico-pneu fi-des-servico-pneu ~
fi-cd-causa-pneu fi-des-causa-pneu fi-cod-sit-eqpto-pneu ~
fi-des-sit-eqpto-pneu tgEntraMedia btConsultaPneu fi-cd-causa-compon ~
fi-des-causa-compon fi-cod-sit-eqpto-compon fi-des-sit-eqpto-compon ~
btConsultaCompon btOK btCancel btHelp2 rtToolBar RECT-20 RECT-21 
&Scoped-Define DISPLAYED-OBJECTS fi-ep-codigo fi-cod-eqpto ~
fi-eqpto-descricao fi-dat-situacao fi-hra-situacao fi-cod-servico-pneu ~
fi-des-servico-pneu fi-cd-causa-pneu fi-des-causa-pneu ~
fi-cod-sit-eqpto-pneu fi-des-sit-eqpto-pneu tgEntraMedia fi-cd-causa-compon ~
fi-des-causa-compon fi-cod-sit-eqpto-compon fi-des-sit-eqpto-compon 

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

DEFINE BUTTON btConsultaCompon 
     IMAGE-UP FILE "image~\im-estru":U
     IMAGE-INSENSITIVE FILE "image~\im-estru":U
     LABEL "" 
     SIZE 4 BY 1.25 TOOLTIP "Consulta Componente".

DEFINE BUTTON btConsultaPneu 
     IMAGE-UP FILE "image~\im-pneu":U
     IMAGE-INSENSITIVE FILE "image~\im-pneu":U
     LABEL "" 
     SIZE 4 BY 1.25 TOOLTIP "Consulta Pneu".

DEFINE BUTTON btHelp2 
     LABEL "Ajuda" 
     SIZE 10 BY 1.

DEFINE BUTTON btOK 
     LABEL "OK" 
     SIZE 10 BY 1.

DEFINE VARIABLE fi-cd-causa-compon AS CHARACTER FORMAT "x(8)" 
     LABEL "Causa":R7 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88.

DEFINE VARIABLE fi-cd-causa-pneu AS CHARACTER FORMAT "x(8)" 
     LABEL "Causa":R7 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88.

DEFINE VARIABLE fi-cod-eqpto AS CHARACTER FORMAT "x(16)" 
     VIEW-AS FILL-IN 
     SIZE 17 BY .88.

DEFINE VARIABLE fi-cod-servico-pneu AS CHARACTER FORMAT "x(4)" 
     LABEL "Serviáo":R9 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88.

DEFINE VARIABLE fi-cod-sit-eqpto-compon AS CHARACTER FORMAT "x(8)" 
     LABEL "Situaá∆o":R10 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88.

DEFINE VARIABLE fi-cod-sit-eqpto-pneu AS CHARACTER FORMAT "x(8)" 
     LABEL "Situaá∆o":R10 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88.

DEFINE VARIABLE fi-dat-situacao AS DATE FORMAT "99/99/9999" 
     LABEL "Data Desativaá∆o":R5 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88.

DEFINE VARIABLE fi-des-causa-compon AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 55 BY .88 NO-UNDO.

DEFINE VARIABLE fi-des-causa-pneu AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 55 BY .88 NO-UNDO.

DEFINE VARIABLE fi-des-servico-pneu AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 55 BY .88 NO-UNDO.

DEFINE VARIABLE fi-des-sit-eqpto-compon AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 55 BY .88 NO-UNDO.

DEFINE VARIABLE fi-des-sit-eqpto-pneu AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 55 BY .88 NO-UNDO.

DEFINE VARIABLE fi-ep-codigo LIKE empresa.ep-codigo
     LABEL "Equipamento":R11 
     VIEW-AS FILL-IN 
     SIZE 4 BY .88 NO-UNDO.

DEFINE VARIABLE fi-eqpto-descricao AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 36 BY .88 NO-UNDO.

DEFINE VARIABLE fi-hra-situacao AS CHARACTER FORMAT "99:99:99" INITIAL "00:00:00" 
     VIEW-AS FILL-IN 
     SIZE 8 BY .88.

DEFINE RECTANGLE RECT-20
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 89 BY 4.83.

DEFINE RECTANGLE RECT-21
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 89 BY 3.17.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE  
     SIZE 90 BY 1.42
     BGCOLOR 7 .

DEFINE VARIABLE tgEntraMedia AS LOGICAL INITIAL no 
     LABEL "Entra na MÇdia Durabilidade" 
     VIEW-AS TOGGLE-BOX
     SIZE 23 BY .83 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fpage0
     fi-ep-codigo AT ROW 1.54 COL 15.72 COLON-ALIGNED
          LABEL "Equipamento":R11
     fi-cod-eqpto AT ROW 1.54 COL 20.14 COLON-ALIGNED HELP
          "C¢digo do Equipamento" NO-LABEL
     fi-eqpto-descricao AT ROW 1.54 COL 37.57 COLON-ALIGNED NO-LABEL
     fi-dat-situacao AT ROW 2.54 COL 15.72 COLON-ALIGNED HELP
          "Data da Situaá∆o"
     fi-hra-situacao AT ROW 2.54 COL 26 COLON-ALIGNED HELP
          "Hora Situaá∆o" NO-LABEL
     fi-cod-servico-pneu AT ROW 4.79 COL 8 COLON-ALIGNED HELP
          "C¢digo Serviáo"
     fi-des-servico-pneu AT ROW 4.79 COL 18.43 COLON-ALIGNED NO-LABEL
     fi-cd-causa-pneu AT ROW 5.79 COL 8 COLON-ALIGNED HELP
          "C¢digo Causa"
     fi-des-causa-pneu AT ROW 5.79 COL 18.43 COLON-ALIGNED NO-LABEL
     fi-cod-sit-eqpto-pneu AT ROW 6.79 COL 8 COLON-ALIGNED HELP
          "C¢digo da Situacao do Pneu"
     fi-des-sit-eqpto-pneu AT ROW 6.79 COL 18.43 COLON-ALIGNED NO-LABEL
     tgEntraMedia AT ROW 7.92 COL 9.86
     btConsultaPneu AT ROW 5.5 COL 79
     fi-cd-causa-compon AT ROW 9.92 COL 8 COLON-ALIGNED HELP
          "C¢digo Causa"
     fi-des-causa-compon AT ROW 9.92 COL 18.43 COLON-ALIGNED NO-LABEL
     fi-cod-sit-eqpto-compon AT ROW 10.92 COL 8 COLON-ALIGNED HELP
          "C¢digo da Situacao do Pneu"
     fi-des-sit-eqpto-compon AT ROW 10.92 COL 18.43 COLON-ALIGNED NO-LABEL
     btConsultaCompon AT ROW 10.17 COL 79
     btOK AT ROW 12.83 COL 2
     btCancel AT ROW 12.83 COL 13
     btHelp2 AT ROW 12.83 COL 80
     "Pneus" VIEW-AS TEXT
          SIZE 5 BY .54 AT ROW 3.88 COL 4
     "Componentes" VIEW-AS TEXT
          SIZE 10 BY .54 AT ROW 9.08 COL 4
     rtToolBar AT ROW 12.63 COL 1
     RECT-20 AT ROW 4.17 COL 1.43
     RECT-21 AT ROW 9.33 COL 1.43
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 90 BY 13.04
         FONT 1.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Window
   Allow: Basic,Browse,DB-Fields,Window,Query
   Add Fields to: Neither
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW wWindow ASSIGN
         HIDDEN             = YES
         TITLE              = ""
         HEIGHT             = 13.04
         WIDTH              = 90
         MAX-HEIGHT         = 17
         MAX-WIDTH          = 90
         VIRTUAL-HEIGHT     = 17
         VIRTUAL-WIDTH      = 90
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
   FRAME-NAME Custom                                                    */
/* SETTINGS FOR FILL-IN fi-ep-codigo IN FRAME fpage0
   LIKE = ems2cad.empresa.ep-codigo EXP-LABEL EXP-SIZE                  */
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
    return "NOK":U.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btConsultaCompon
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btConsultaCompon wWindow
ON CHOOSE OF btConsultaCompon IN FRAME fpage0
DO:
    run piChamaPrograma in this-procedure (input "cop/co0604.w":U).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btConsultaPneu
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btConsultaPneu wWindow
ON CHOOSE OF btConsultaPneu IN FRAME fpage0
DO:
    run piChamaPrograma in this-procedure (input "pnp/pn0605.w":U).
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
do:
    run piGrava in this-procedure.
    if return-value = "OK":U then do:
        if mab-eqpto.dat-situacao = ? then do:
            apply "CLOSE":U to this-procedure.
        end.
        else do:
            run piAlteraMovto in this-procedure.
            if return-value = "OK":U then do:
                apply "CLOSE":U to this-procedure.
            end.
            else do:
                return.
            end.
        end.
    end.
    else do:
        return.
    end.
    if (c-nom-prog-upc-mg97 <> "" and
        c-nom-prog-upc-mg97 <> ?) then do:
        run value(c-nom-prog-upc-mg97) (input "BOTAO-OK":U,
                                        input "",
                                        input this-procedure,
                                        input frame fpage0:handle,
                                        input "",
                                        input ?).
    end.
    return "OK":U.
end.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fi-cd-causa-compon
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-cd-causa-compon wWindow
ON F5 OF fi-cd-causa-compon IN FRAME fpage0 /* Causa */
OR MOUSE-SELECT-DBLCLICK OF fi-cd-causa-compon IN FRAME fpage0
DO:
    {method/zoomfields.i 
       &ProgramZoom="mnzoom/z01mn082.w"
       &FieldZoom1="cd-causa-padr"
       &FieldScreen1="fi-cd-causa-compon"
       &Frame1="fPage0"
       &FieldZoom2="descricao"
       &FieldScreen2="fi-des-causa-compon"
       &Frame2="fPage0"
       &EnableImplant="YES"}
       
     wait-for "CLOSE":U of hProgramZoom.
     apply "LEAVE":U to self.       
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-cd-causa-compon wWindow
ON LEAVE OF fi-cd-causa-compon IN FRAME fpage0 /* Causa */
DO:
  /*  {method/ReferenceFields.i
        &HandleDBOLeave="hDBOCausa"
        &KeyValue1="fi-cd-causa-compon:screen-value in frame fPage0"
        &FieldName1="descricao"
        &FieldScreen1="fi-des-causa-compon"
        &Frame1="fPage0"}    */
        
    for first causa-padrao
        where causa-padrao.cd-causa-padr = fi-cd-causa-compon:screen-value in frame fPage0 no-lock:
            assign fi-des-causa-compon:screen-value in frame fPage0 = causa-padrao.descricao.
    end.
    IF fi-cd-causa-compon:screen-value in frame fPage0 = "" THEN
        assign fi-des-causa-compon:screen-value in frame fPage0 = "".
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fi-cd-causa-pneu
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-cd-causa-pneu wWindow
ON F5 OF fi-cd-causa-pneu IN FRAME fpage0 /* Causa */
OR MOUSE-SELECT-DBLCLICK OF fi-cd-causa-pneu IN FRAME fpage0
DO:
    {method/zoomfields.i 
       &ProgramZoom="mnzoom/z01mn082.w"
       &FieldZoom1="cd-causa-padr"
       &FieldScreen1="fi-cd-causa-pneu"
       &Frame1="fPage0"
       &FieldZoom2="descricao"
       &FieldScreen2="fi-des-causa-pneu"
       &Frame2="fPage0"
       &EnableImplant="YES"}
       
     wait-for "CLOSE":U of hProgramZoom.
     apply "LEAVE":U to self.       
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-cd-causa-pneu wWindow
ON LEAVE OF fi-cd-causa-pneu IN FRAME fpage0 /* Causa */
DO:
    /*{method/ReferenceFields.i
        &HandleDBOLeave="hDBOCausa"
        &KeyValue1="fi-cd-causa-pneu:screen-value in frame fPage0"
        &FieldName1="descricao"
        &FieldScreen1="fi-des-causa-pneu"
        &Frame1="fPage0"}*/
        
    for first causa-padrao
        where causa-padrao.cd-causa-padr = fi-cd-causa-pneu:screen-value in frame fPage0 no-lock:
            assign fi-des-causa-pneu:screen-value in frame fPage0 = causa-padrao.descricao.
    end.
    IF fi-cd-causa-pneu:screen-value in frame fPage0 = "" THEN
        assign fi-des-causa-pneu:screen-value in frame fPage0 = "".
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fi-cod-servico-pneu
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-cod-servico-pneu wWindow
ON F5 OF fi-cod-servico-pneu IN FRAME fpage0 /* Serviáo */
OR MOUSE-SELECT-DBLCLICK OF fi-cod-servico-pneu IN FRAME fpage0
DO:
    {method/zoomfields.i 
       &ProgramZoom="frzoom/z01fr053.w"
       &FieldZoom1="cod-servico"
       &FieldScreen1="fi-cod-servico-pneu"
       &Frame1="fPage0"
       &FieldZoom2="des-servico"
       &FieldScreen2="fi-des-servico-pneu"
       &Frame2="fPage0"
       &EnableImplant="YES"}
     wait-for "CLOSE":U of hProgramZoom.
     apply "LEAVE":U to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-cod-servico-pneu wWindow
ON LEAVE OF fi-cod-servico-pneu IN FRAME fpage0 /* Serviáo */
DO:
    for first mpn-serv
        where mpn-serv.cod-servico = fi-cod-servico-pneu:screen-value in frame fPage0 no-lock:
        assign fi-des-servico-pneu:screen-value in frame fPage0 = des-servico.
    end.
    IF fi-cod-servico-pneu:screen-value in frame fPage0 = "" THEN
        assign fi-des-servico-pneu:screen-value in frame fPage0 = "".
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fi-cod-sit-eqpto-compon
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-cod-sit-eqpto-compon wWindow
ON F5 OF fi-cod-sit-eqpto-compon IN FRAME fpage0 /* Situaá∆o */
OR MOUSE-SELECT-DBLCLICK OF fi-cod-sit-eqpto-compon IN FRAME fpage0
DO:
    {method/zoomfields.i 
       &ProgramZoom="frzoom/z01fr024.w"
       &FieldZoom1="cod-sit-eqpto"
       &FieldScreen1="fi-cod-sit-eqpto-compon"
       &Frame1="fPage0"
       &FieldZoom2="des-sit-eqpto"
       &FieldScreen2="fi-des-sit-eqpto-compon"
       &Frame2="fPage0"
       &EnableImplant="YES"}    
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-cod-sit-eqpto-compon wWindow
ON LEAVE OF fi-cod-sit-eqpto-compon IN FRAME fpage0 /* Situaá∆o */
DO:
  /*  {method/ReferenceFields.i
        &HandleDBOLeave="hDBOSit"
        &KeyValue1="fi-cod-sit-eqpto-compon:screen-value in frame fPage0"
        &FieldName1="des-sit-eqpto"
        &FieldScreen1="fi-des-sit-eqpto-compon"
        &Frame1="fPage0"}   */

    for first mab-sit-eqpto
        where mab-sit-eqpto.cod-sit-eqpto = fi-cod-sit-eqpto-compon:screen-value in frame fPage0 no-lock:
        assign fi-des-sit-eqpto-compon:screen-value in frame fPage0 = mab-sit-eqpto.des-sit-eqpto.
    end.
    IF fi-cod-sit-eqpto-compon:screen-value in frame fPage0 = "" THEN
        assign fi-des-sit-eqpto-compon:screen-value in frame fPage0 = "".
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fi-cod-sit-eqpto-pneu
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-cod-sit-eqpto-pneu wWindow
ON F5 OF fi-cod-sit-eqpto-pneu IN FRAME fpage0 /* Situaá∆o */
OR MOUSE-SELECT-DBLCLICK OF fi-cod-sit-eqpto-pneu IN FRAME fpage0
DO:
    {method/zoomfields.i 
       &ProgramZoom="frzoom/z01fr024.w"
       &FieldZoom1="cod-sit-eqpto"
       &FieldScreen1="fi-cod-sit-eqpto-pneu"
       &Frame1="fPage0"
       &FieldZoom2="des-sit-eqpto"
       &FieldScreen2="fi-des-sit-eqpto-pneu"
       &Frame2="fPage0"
       &EnableImplant="YES"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-cod-sit-eqpto-pneu wWindow
ON LEAVE OF fi-cod-sit-eqpto-pneu IN FRAME fpage0 /* Situaá∆o */
DO:
    /*{method/ReferenceFields.i
        &HandleDBOLeave="hDBOSit"
        &KeyValue1="fi-cod-sit-eqpto-pneu:screen-value in frame fPage0"
        &FieldName1="des-sit-eqpto"
        &FieldScreen1="fi-des-sit-eqpto-pneu"
        &Frame1="fPage0"}   */ 
        
    for first mab-sit-eqpto
        where mab-sit-eqpto.cod-sit-eqpto = fi-cod-sit-eqpto-pneu:screen-value in frame fPage0 no-lock:
        assign fi-des-sit-eqpto-pneu:screen-value in frame fPage0 = mab-sit-eqpto.des-sit-eqpto.
    end.
    IF fi-cod-sit-eqpto-pneu:screen-value in frame fPage0 = "" THEN
        ASSIGN fi-des-sit-eqpto-pneu:screen-value in frame fPage0 = "".
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


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
    /** Adiciona labels nos campos **/
    {utp/ut-liter.i Equipamento}
    assign fi-ep-codigo:label            in frame fPage0 = return-value.
    {utp/ut-liter.i Data_Desativaá∆o}
    assign fi-dat-situacao:label         in frame fPage0 = return-value.
    {utp/ut-liter.i Serviáo}
    assign fi-cod-servico-pneu:label     in frame fPage0 = return-value.
    {utp/ut-liter.i Causa}
    assign fi-cd-causa-pneu:label        in frame fPage0 = return-value.
    assign fi-cd-causa-compon:label      in frame fPage0 = return-value.
    {utp/ut-liter.i Situaá∆o}
    assign fi-cod-sit-eqpto-pneu:label   in frame fPage0 = return-value.
    assign fi-cod-sit-eqpto-compon:label in frame fPage0 = return-value.

    /** Efeito de lupa nos campos estrangeiros **/
    fi-cod-servico-pneu:load-mouse-pointer("image/lupa.cur":U)     in frame fPage0.
    fi-cd-causa-pneu:load-mouse-pointer("image/lupa.cur":U)        in frame fPage0.
    fi-cod-sit-eqpto-pneu:load-mouse-pointer("image/lupa.cur":U)   in frame fPage0.
    fi-cd-causa-compon:load-mouse-pointer("image/lupa.cur":U)      in frame fPage0.
    fi-cod-sit-eqpto-compon:load-mouse-pointer("image/lupa.cur":U) in frame fPage0.

    /** Habilita e desabilita campos **/
    assign fi-ep-codigo:sensitive            in frame fPage0 = no
           fi-cod-eqpto:sensitive            in frame fPage0 = no
           fi-eqpto-descricao:sensitive      in frame fPage0 = no
           fi-dat-situacao:sensitive         in frame fPage0 = no
           fi-hra-situacao:sensitive         in frame fPage0 = no
           fi-des-servico-pneu:sensitive     in frame fPage0 = no
           fi-des-causa-pneu:sensitive       in frame fPage0 = no
           fi-des-causa-compon:sensitive     in frame fPage0 = no
           fi-des-sit-eqpto-pneu:sensitive   in frame fPage0 = no
           fi-des-sit-eqpto-compon:sensitive in frame fPage0 = no
           fi-cod-servico-pneu:sensitive     in frame fPage0 = yes
           fi-cd-causa-pneu:sensitive        in frame fPage0 = yes
           fi-cd-causa-compon:sensitive      in frame fPage0 = yes
           fi-cod-sit-eqpto-pneu:sensitive   in frame fPage0 = yes
           fi-cod-sit-eqpto-compon:sensitive in frame fPage0 = yes
           tgEntraMedia:sensitive            in frame fPage0 = yes.

    if not can-find(first mpn-pneu
                    where mpn-pneu.ep-codigo-atual = p-ep-codigo
                    and   mpn-pneu.cod-eqpto-atual = p-cod-eqpto no-lock) then do:
        assign fi-cod-servico-pneu:sensitive in frame fPage0      = no
               fi-cod-servico-pneu:screen-value in frame fPage0   = ""
               fi-cd-causa-pneu:sensitive in frame fPage0         = no
               fi-cd-causa-pneu:screen-value in frame fPage0      = ""
               fi-cod-sit-eqpto-pneu:sensitive in frame fPage0    = no
               fi-cod-sit-eqpto-pneu:screen-value in frame fPage0 = ""
               tgEntraMedia:sensitive in frame fPage0             = no
               btConsultaPneu:sensitive in frame fPage0           = no.
    end.
    if not can-find(first mco-compon
                    where mco-compon.ep-codigo-atual = p-ep-codigo
                    and   mco-compon.cod-eqpto-atual = p-cod-eqpto no-lock) then do:
        assign fi-cd-causa-compon:sensitive in frame fPage0         = no
               fi-cd-causa-compon:screen-value in frame fPage0      = ""
               fi-cod-sit-eqpto-compon:sensitive in frame fPage0    = no
               fi-cod-sit-eqpto-compon:screen-value in frame fPage0 = ""
               btConsultaCompon:sensitive in frame fPage0           = no.
    end.

    apply "LEAVE":U to fi-cod-servico-pneu      in frame fPage0.
    apply "LEAVE":U to fi-cd-causa-pneu         in frame fPage0.
    apply "LEAVE":U to fi-cod-sit-eqpto-pneu    in frame fPage0.
    apply "LEAVE":U to fi-cd-causa-compon       in frame fPage0.
    apply "LEAVE":U to fi-cod-sit-eqpto-compon  in frame fPage0.

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
/** Busca equipamento conforme chave passada por parametro **/
    for first mab-eqpto
        where mab-eqpto.ep-codigo = p-ep-codigo
        and   mab-eqpto.cod-eqpto = p-cod-eqpto no-lock:

        /** Preenche campos em tela com valores dos parametros **/
        assign fi-ep-codigo    = mab-eqpto.ep-codigo
               fi-cod-eqpto    = mab-eqpto.cod-eqpto
               fi-dat-situacao = p-dat-situacao
               fi-hra-situacao = p-hra-situacao.

        /** Busca modelo **/
        for first mab-model
            where mab-model.cod-model = mab-eqpto.cod-model no-lock:
            assign fi-eqpto-descricao = mab-model.des-model.
        end.
    end.

    /** Verifica se Ç movimento de inativacao do equipamento ou se equipamento j† est† inativo **/
    if mab-eqpto.dat-situacao = ? then do:
        /** Aplica valores dos parametros como preferenciais **/
        find first mpn-param no-lock no-error.
        if not avail mpn-param then return "OK":U.
        if can-find(first mpn-pneu
                    where mpn-pneu.ep-codigo-atual = p-ep-codigo
                    and   mpn-pneu.cod-eqpto-atual = p-cod-eqpto no-lock) then do:
            for first mpn-serv
                where mpn-serv.cod-servico = mpn-param.cod-serv-transf no-lock:
                assign fi-cod-servico-pneu = mpn-param.cod-serv-transf
                       fi-cd-causa-pneu = mpn-serv.cd-causa-padr.
            end.
        end.
        if can-find(first mco-compon
                    where mco-compon.ep-codigo-atual = p-ep-codigo
                    and   mco-compon.cod-eqpto-atual = p-cod-eqpto no-lock) then do:
            for first mab-param
                where mab-param.cdn-param = 46 no-lock:
                assign fi-cd-causa-compon = mab-param.des-valor.
            end.
        end.
    end.
    else do:
        /** Busca Pneus **/
        for first mpn-pneu
            where mpn-pneu.ep-codigo-atual = mab-eqpto.ep-codigo
            and   mpn-pneu.cod-eqpto-atual = mab-eqpto.cod-eqpto
            and   mpn-pneu.dat-situacao <> ? no-lock:
            for last mpn-movto-pneu
                where mpn-movto-pneu.cod-pneu = mpn-pneu.cod-pneu no-lock use-index mpnmvtpn-03:  
                assign fi-cod-servico-pneu   = mpn-movto-pneu.cod-servico
                       fi-cd-causa-pneu      = mpn-movto-pneu.cd-causa-padr
                       fi-cod-sit-eqpto-pneu = mpn-movto-pneu.cod-sit-eqpto.
            end.
            for last mpn-histor-vida where mpn-histor-vida.cod-pneu = mpn-pneu.cod-pneu no-lock:
                assign tgEntraMedia = mpn-histor-vida.log-km-final-confiav.
            end.
        end.
        /** Busca Componentes **/
        for first mco-compon
            where mco-compon.ep-codigo-atual = mab-eqpto.ep-codigo
            and   mco-compon.cod-eqpto-atual = mab-eqpto.cod-eqpto
            and   mco-compon.dat-situacao <> ? no-lock:
            for last mco-movto-compon
                where mco-movto-compon.cod-compon = mco-compon.cod-compon no-lock by mco-movto-compon.dat-movto:
                assign fi-cd-causa-compon      = substring(mco-movto-compon.cod-livre-1,21,08)
                       fi-cod-sit-eqpto-compon = mco-movto-compon.cod-sit-eqpto.
            end.
        end.
    end.

    return "OK":U.

end procedure.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piAlteraMovto wWindow 
PROCEDURE piAlteraMovto :
/*------------------------------------------------------------------------------
  Purpose:
  Parameters:  <none>
  Notes:
------------------------------------------------------------------------------*/
    {method/showmessage.i1}
    empty temp-table RowErrors.

    /*--- DBO Movimento Pneus ---*/
    if not valid-handle(hDBOMovtoPneu)     or
       hDBOMovtoPneu:type <> "PROCEDURE":U or
       hDBOMovtoPneu:file-name <> "frbo/bofr074.p":U then do:
        run frbo/bofr074.p persistent set hDBOMovtoPneu.
    end.

    run openQueryStatic in hDBOMovtoPneu (input "Main":U) no-error.

    /*--- DBO Movimento Componentes ---*/
    if not valid-handle(hDBOMovtoCompon)     or
       hDBOMovtoCompon:type <> "PROCEDURE":U or
       hDBOMovtoCompon:file-name <> "frbo/bofr066.p":U then do:
        run frbo/bofr066.p persistent set hDBOMovtoCompon.
    end.

    run openQueryStatic in hDBOMovtoCompon (input "Main":U) no-error.

    run setaPrograma in hDBOMovtoPneu (input "ABAPI014":U).

    /** Busca Pneus **/
    for each  mpn-pneu
        where mpn-pneu.ep-codigo-atual = mab-eqpto.ep-codigo
        and   mpn-pneu.cod-eqpto-atual = mab-eqpto.cod-eqpto
        and   mpn-pneu.dat-situacao <> ? no-lock:
        for last mpn-movto-pneu
            where mpn-movto-pneu.cod-pneu = mpn-pneu.cod-pneu no-lock use-index mpnmvtpn-03:
            empty temp-table tt-mpn-movto-pneu.
            run goToKey in hDBOMovtoPneu (input mpn-movto-pneu.num-docto).
            run getRecord in hDBOMovtoPneu (output table tt-mpn-movto-pneu).
            for first tt-mpn-movto-pneu no-lock:
                assign tt-mpn-movto-pneu.cod-servico      = fi-cod-servico-pneu:screen-value in frame fPage0
                       tt-mpn-movto-pneu.cd-causa-padr    = fi-cd-causa-pneu:screen-value in frame fPage0
                       tt-mpn-movto-pneu.cod-sit-eqpto    = fi-cod-sit-eqpto-pneu:screen-value in frame fPage0
                       tt-mpn-movto-pneu.dat-movto        = p-dat-situacao
                       tt-mpn-movto-pneu.hra-inic-apont   = p-hra-situacao.
            end.
            run deleteRecord in hDBOMovtoPneu.
            run emptyRowErrors in hDBOMovtoPneu.
            run setRecord in hDBOMovtoPneu (input table tt-mpn-movto-pneu).
            run createRecord in hDBOMovtoPneu.
            if return-value = "NOK":U then do:
                run getRowErrors in hDBOMovtoPneu (output table RowErrors).
                {method/showmessage.i2 &Modal=YES}
                run emptyRowErrors in hDBOMovtoPneu.
            end.

            for last mpn-histor-vida where mpn-histor-vida.cod-pneu = tt-mpn-movto-pneu.cod-pneu exclusive-lock:
                assign mpn-histor-vida.log-km-final-confiav = tgEntraMedia:checked in frame fPage0.
            end.
        end.
    end.
    /** Busca Componentes **/
    for each  mco-compon
        where mco-compon.ep-codigo-atual = mab-eqpto.ep-codigo
        and   mco-compon.cod-eqpto-atual = mab-eqpto.cod-eqpto
        and   mco-compon.dat-situacao <> ? no-lock:
        for last mco-movto-compon
            where mco-movto-compon.cod-compon = mco-compon.cod-compon no-lock by mco-movto-compon.dat-movto:
            empty temp-table tt-mco-movto-compon.
            run goToKey in hDBOMovtoCompon (input mco-movto-compon.num-docto).
            run getRecord in hDBOMovtoCompon (output table tt-mco-movto-compon).
            for first tt-mco-movto-compon exclusive-lock:
                assign overlay(tt-mco-movto-compon.cod-livre-1,21,08) = fi-cd-causa-compon:screen-value in frame fPage0
                       tt-mco-movto-compon.cod-sit-eqpto              = fi-cod-sit-eqpto-compon:screen-value in frame fPage0
                       tt-mco-movto-compon.dat-movto                  = p-dat-situacao
                       tt-mco-movto-compon.hra-movto                  = p-hra-situacao.
            end.
            run deleteRecord in hDBOMovtoCompon.
            run emptyRowErrors in hDBOMovtoCompon.
            run setRecord in hDBOMovtoCompon (input table tt-mco-movto-compon).
            run createRecord in hDBOMovtoCompon.
            if return-value = "NOK":U then do:
                run getRowErrors in hDBOMovtoCompon (output table RowErrors).
                {method/showmessage.i2 &Modal=YES}
                run emptyRowErrors in hDBOMovtoCompon.
            end.
        end.
    end.

    {method/showmessage.i3}

    return "OK":U.

end procedure.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piChamaPrograma wWindow 
PROCEDURE piChamaPrograma :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    define variable hProgram  as handle   no-undo.
    define variable rGoTo     as rowid    no-undo.

    define input parameter pProgram as character no-undo.
    
        /*--- Seta cursor do mouse para espera ---*/
        session:set-wait-state("GENERAL":U).
        assign {&window-name}:sensitive = no.
        /*--- Executa programa de inclus∆o de filho ---*/
        run value(pProgram) persistent set hProgram.

        /*--- BO Equipamento ---*/
        if not valid-handle(hDBOEquipto)     or
           hDBOEquipto:type <> "PROCEDURE":U or
           hDBOEquipto:file-name <> "frbo/bofr007.p":U then do:
            run frbo/bofr007.p persistent set hDBOEquipto.
        end.
        run openQueryStatic in hDBOEquipto (input "Main":U) no-error.
        
        /* novo mÇtodo de teste do valid-handle */
        if valid-handle(hProgram)         and
            hProgram:type = "PROCEDURE":U and
            hProgram:file-name = pProgram then
            /*--- Inicializa programa de inclus∆o de filho ---*/
            run initializeInterface in hProgram.
        
        if valid-handle(hProgram) then do:
            /** Reposiciona programa no registro **/
            run goToKey in hDBOEquipto (input int(fi-ep-codigo:screen-value in frame fPage0),
                                        input fi-cod-eqpto:screen-value in frame fPage0).
            if return-value = "OK":U then do:
                run getRowid in hDBOEquipto (output rGoTo).
                run repositionRecord in hProgram (input rGoTo).
            end.
            /*--- Seta cursor do mouse para normal ---*/
            session:set-wait-state("":U).
            wait-for "CLOSE":U of hProgram.
        end.
        assign {&window-name}:sensitive = yes.
        
        if valid-handle(hProgram) then
            delete procedure hProgram.

    return "OK":U.

end procedure.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piGrava wWindow 
PROCEDURE piGrava :
/*------------------------------------------------------------------------------
  Purpose:
  Parameters:  <none>
  Notes:
------------------------------------------------------------------------------*/
    define variable cTexto  as character  no-undo.
    define variable cTexto2 as character  no-undo.

    for first mab-sit-eqpto
        where mab-sit-eqpto.cod-sit-eqpto = fi-cod-sit-eqpto-pneu:screen-value in frame fPage0 no-lock:
        if mab-sit-eqpto.idi-tip = 1 then do:
            {utp/ut-liter.i "O c¢digo da situaá∆o do equipamento deve ser de inativaá∆o"}
            assign cTexto  = return-value.
            {utp/ut-liter.i "O serviáo informado deve ser do tipo 'Inativo'"}.
            assign cTexto2 = return-value.
            run utp/ut-msgs.p (input "Error":U,
                               input 17006,
                               input cTexto + "." +
                               "~~" + cTexto2 + ".").
            return "NOK":U.
        end.
    end.
    for first mab-sit-eqpto
        where mab-sit-eqpto.cod-sit-eqpto = fi-cod-sit-eqpto-compon:screen-value in frame fPage0 no-lock:
        if mab-sit-eqpto.idi-tip = 1 then do:
            {utp/ut-liter.i "O c¢digo da situaá∆o do componente deve ser de inativaá∆o"}
            assign cTexto  = return-value.
            {utp/ut-liter.i "O serviáo informado deve ser do tipo 'Inativo'"}.
            assign cTexto2 = return-value.
            run utp/ut-msgs.p (input "Error":U,
                               input 17006,
                               input cTexto + "." +
                               "~~" + cTexto2 + ".").
            return "NOK":U.
        end.
    end.

    assign p-cod-servico-pneu     = fi-cod-servico-pneu:screen-value     in frame fPage0
           p-cd-causa-pneu        = fi-cd-causa-pneu:screen-value        in frame fPage0
           p-cod-situacao-pneu    = fi-cod-sit-eqpto-pneu:screen-value   in frame fPage0
           p-cd-causa-compon      = fi-cd-causa-compon:screen-value      in frame fPage0
           p-cod-situacao-compon  = fi-cod-sit-eqpto-compon:screen-value in frame fPage0
           p-entra-media          = tgEntraMedia:checked                 in frame fPage0.

    return "OK":U.

end procedure.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

