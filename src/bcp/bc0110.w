&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
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
{include/i-prgvrs.i BC0110 2.00.00.005}  /*** 010005 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i bc0110 MBC}
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
&GLOBAL-DEFINE Program        BC0110
&GLOBAL-DEFINE Version        2.00.00.005

&GLOBAL-DEFINE WindowType     Detail

&GLOBAL-DEFINE Folder         NO
&GLOBAL-DEFINE InitialPage    1
&GLOBAL-DEFINE FolderLabels   

&GLOBAL-DEFINE page0Widgets   btOK btCancel btlimpar btHelp2
&GLOBAL-DEFINE page1Widgets   
&GLOBAL-DEFINE page2Widgets   

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

/* Includes para DBOÔs */
{clbo/bocl029.i tt-emitente-etiqueta}

/* handle para DBOÔs */
DEFINE VARIABLE hBOCL029     AS HANDLE NO-UNDO.

/* temp table de erro */
{cdp/cd0666.i}

/* Convers∆o tt-campos para XML - tt-xml para bcapi017 */
{bcp/bcapi017.i}        

/* Decodificaá∆o da String 2d - tt-campos para bcapi019 */
{bcp/bcapi019.i}

/* Geraá∆o do Movimento no DC - tt-trans e tt-trans-filho para bcapi001.p */
{bcp/bcapi001.i}

/* Definiá‰es das procedures para integraá∆o com o Magnus i.00 */
{bcp/bcproxy.i2}

/* Local Variable Definitions ---                                       */
DEFINE NEW GLOBAL SHARED VARIABLE adm-broker-hdl AS HANDLE NO-UNDO.
DEFINE VARIABLE wh-pesquisa    AS HANDLE NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fpage0

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS RECT-1 RECT-2 rtToolBar f-cgc f-nome-abrev ~
f-nome-emit f-tipo-etiq f-cod-layout tb-log-datasul f-descricao ed-dados-nf ~
btOK btlimpar btCancel btHelp2 f-texto-nf 
&Scoped-Define DISPLAYED-OBJECTS f-cgc f-nome-abrev f-nome-emit f-tipo-etiq ~
f-cod-layout tb-log-datasul f-descricao ed-dados-nf f-texto-nf 

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

DEFINE BUTTON btlimpar 
     LABEL "Limpar" 
     SIZE 10 BY 1.

DEFINE BUTTON btOK 
     LABEL "&Executar" 
     SIZE 10 BY 1.

DEFINE VARIABLE ed-dados-nf AS CHARACTER 
     VIEW-AS EDITOR SCROLLBAR-VERTICAL
     SIZE 77 BY 9.75
     FONT 2 NO-UNDO.

DEFINE VARIABLE f-cgc AS CHARACTER FORMAT "x(19)" 
     LABEL "CGC/CPF":R9 
     VIEW-AS FILL-IN 
     SIZE 18 BY .88.

DEFINE VARIABLE f-cod-layout AS INTEGER FORMAT ">>>9" INITIAL 0 
     LABEL "Layout" 
     VIEW-AS FILL-IN 
     SIZE 5 BY .88.

DEFINE VARIABLE f-descricao AS CHARACTER FORMAT "X(50)" 
     VIEW-AS FILL-IN 
     SIZE 30 BY .88.

DEFINE VARIABLE f-nome-abrev AS CHARACTER FORMAT "X(12)" 
     LABEL "Nome ou C¢digo":R17 
     VIEW-AS FILL-IN 
     SIZE 15 BY .88.

DEFINE VARIABLE f-nome-emit AS CHARACTER FORMAT "X(40)" 
     LABEL "Nome" 
     VIEW-AS FILL-IN 
     SIZE 50 BY .88.

DEFINE VARIABLE f-texto-nf AS CHARACTER FORMAT "X(256)":U INITIAL "C¢digo 2D" 
      VIEW-AS TEXT 
     SIZE 11 BY .67 NO-UNDO.

DEFINE VARIABLE f-tipo-etiq AS INTEGER FORMAT "9999" INITIAL 0 
     LABEL "Tipo Etiqueta":R16 
     VIEW-AS FILL-IN 
     SIZE 5 BY .88.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 79 BY 10.75.

DEFINE RECTANGLE RECT-2
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 79 BY 3.75.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE  
     SIZE 80 BY 1.42
     BGCOLOR 7 .

DEFINE VARIABLE tb-log-datasul AS LOGICAL INITIAL no 
     LABEL "Padr∆o Datasul" 
     VIEW-AS TOGGLE-BOX
     SIZE 14 BY .88.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fpage0
     f-cgc AT ROW 1.75 COL 12 COLON-ALIGNED HELP
          "CGC ou CIC do cliente/fornecedor"
     f-nome-abrev AT ROW 1.75 COL 47 COLON-ALIGNED HELP
          "Nome abreviado do cliente/fornecedor"
     f-nome-emit AT ROW 2.75 COL 12 COLON-ALIGNED HELP
          "Nome Completo do Emitente"
     f-tipo-etiq AT ROW 3.75 COL 12 COLON-ALIGNED HELP
          "Tipo de etiqueta"
     f-cod-layout AT ROW 3.75 COL 24 COLON-ALIGNED HELP
          "C¢digo do Layout de Registros"
     tb-log-datasul AT ROW 3.75 COL 33 HELP
          "Indica se o layout Ç padr∆o da Datasul ou do cliente."
     f-descricao AT ROW 3.75 COL 47 COLON-ALIGNED HELP
          "Descriá∆o do layout de registros." NO-LABEL
     ed-dados-nf AT ROW 6 COL 3 NO-LABEL
     btOK AT ROW 16.75 COL 2
     btlimpar AT ROW 16.75 COL 13
     btCancel AT ROW 16.75 COL 24
     btHelp2 AT ROW 16.75 COL 70
     f-texto-nf AT ROW 5.25 COL 2 COLON-ALIGNED NO-LABEL
     RECT-1 AT ROW 5.5 COL 2
     RECT-2 AT ROW 1.25 COL 2
     rtToolBar AT ROW 16.5 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 80.86 BY 17.04
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
         HEIGHT             = 17.04
         WIDTH              = 80.86
         MAX-HEIGHT         = 17.04
         MAX-WIDTH          = 90
         VIRTUAL-HEIGHT     = 17.04
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
   FRAME-NAME                                                           */
ASSIGN 
       ed-dados-nf:RETURN-INSERTED IN FRAME fpage0  = TRUE.

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


&Scoped-define SELF-NAME btlimpar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btlimpar wWindow
ON CHOOSE OF btlimpar IN FRAME fpage0 /* Limpar */
DO:
    ASSIGN ed-dados-nf:SCREEN-VALUE IN FRAME fPage0 = "".
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btOK
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btOK wWindow
ON CHOOSE OF btOK IN FRAME fpage0 /* Executar */
DO:
    RUN processaDocumento.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME ed-dados-nf
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ed-dados-nf wWindow
ON CTRL-T OF ed-dados-nf IN FRAME fpage0
OR  mouse-select-dblclick  OF ed-dados-nf
DO:

    /******************** teste **************
    /* gera dados de teste durante desenvolvimento */
    DEF VAR v-teste AS CHAR INIT "aim" VIEW-AS COMBO-BOX LIST-ITEMS "aim", "fixo", "id", "separad".
    DEF BUTTON btOk AUTO-GO.

    f-nome-abrev:SCREEN-VALUE IN FRAME fPage0 = "01".  
    APPLY "leave" TO f-nome-abrev IN FRAME fPage0.
    UPDATE v-teste btok WITH VIEW-AS DIALOG-BOX DEFAULT-BUTTON btok.
    APPLY "tab" TO SELF.
    FIND tipo-etiqueta 50 EXCLUSIVE-LOCK NO-ERROR.

    IF  v-teste = "aim":U THEN DO:
        tipo-etiqueta.cod-layout = 1000.
        SELF:SCREEN-VALUE = 
            "IT11@NF011511@CE64534647000186@DE19/10/2000@QE5@PL25@VN1000@DAAux@DA     @DAConstante@":U +
            "LP1@CP001@DRComputador@UNPC@QT1@VU600@VR600@IP5@CS000001@":U + CHR(10) +
            "LP2@CP002@DRImpressora@UNPC@QT1@VU400@VR400@IP5@CS000002@":U + CHR(10) + 
            "FP@FT@":U.
    END.

    IF  v-teste = "fixo":U THEN DO:
        tipo-etiqueta.cod-layout = 1002.
        SELF:SCREEN-VALUE = 
            STRING(1, "99999") +
            STRING("CGC-Emit", "x(20)") +
            STRING(TODAY, "99/99/9999") +
            STRING(2, "99999") +
            STRING(25, "99999999999.99999") +
            STRING(1000, "99999999999999.99999") +
            STRING('Aux', 'x(8)') +
            STRING (" ", "x(5)") + 
            STRING('Constante', 'x(9)') + 
            /* item 1 */
            STRING("00001", "x(16)") +
            STRING("Computador", "x(20)") +
            STRING("PC", "x(2)") + 
            STRING(1, '99999999999999.99999') +
            STRING(600, '999999999999999.99999') +
            STRING(600, '99999999999999.99999') +
            STRING(5, "99999.99") +
            STRING("CS00001", "x(14)") +
            CHR(10) + 
            /* item 2 */
            STRING("00002", "x(16)") +
            STRING("Impressora", "x(20)") +
            STRING("PC", "x(2)") + 
            STRING(1, '99999999999999.99999') +
            STRING(400, '999999999999999.99999') +
            STRING(400, '99999999999999.99999') +
            STRING(5, "99999.99") +
            STRING("CS00002", "x(14)") +
            CHR(10).
    END.

    IF  v-teste = "id":U THEN DO:
        tipo-etiqueta.cod-layout = 1001.
        SELF:SCREEN-VALUE = 
            "NF011511@CE64534647000186@DE19/10/2000@QE5@PL25@VN1000@DAAux@DA     @DAConstante@":U +
            "CP001@DRComputador@UNPC@QT1@VU600@VR600@IP5@CS000001@":U + CHR(10) +
            "CP002@DRImpressora@UNPC@QT1@VU400@VR400@IP5@CS000002@":U + CHR(10).
    END.

    IF  v-teste = "separad":U THEN DO:
        tipo-etiqueta.cod-layout = 1003.
        SELF:SCREEN-VALUE = 
            STRING(1) + chr(1) + 
            STRING("CGC-Emit") + chr(1) +
            STRING(TODAY) + chr(1) +
            STRING(2) + chr(1) +
            STRING(25) + chr(1) +
            STRING(1000) + CHR(1) + 
            STRING("Aux") + CHR(1) +
            STRING("     ") + CHR(1) + 
            STRING("Constante") + CHR(2) +
            /* item 1 */
            STRING("00001") + chr(1) +
            STRING("Computador") + chr(1) +
            STRING("PC") + chr(1) + 
            STRING(1) + chr(1) +
            STRING(600) + chr(1) +
            STRING(600) + chr(1) +
            STRING(5) + chr(1) +
            STRING("CS00001") + 
            CHR(2) +
            /* item 2 */
            STRING("00002") + chr(1) +
            STRING("Impressora") + chr(1) +
            STRING("PC") + chr(1) + 
            STRING(1) + chr(1) +
            STRING(400) + chr(1) +
            STRING(400) + chr(1) +
            STRING(5) + chr(1) +
            STRING("CS00002") + 
            CHR(2).
    END.

/* campos nos layouts
    nota fiscal
    'docum-est.nro-docto', 'integer', "99999", "NF", "@"
    'emitente.cgc', 'character', "x(20)", "CE", "@"
    'docum-est.dt-emissao', 'character', "x(10)", "DE", "@"
    "Volumes na NF", 'integer', '99999', "QE", "@"
    'Peso Liquido', 'decimal', '99999999999.99999', "PL", "@"
    'docum-est.tot-valor', 'decimal', '99999999999999.99999', "VN", "@"
    'auxiliar-1', 'character', 'x(8)', 'DA', '@'
    'Constante', '', '', 'DA', '@'

    nota-fiscal-item
    'item-doc-est.it-codigo', 'character', 'x(16)', "CP", "@"
    "item.descricao-1", "character", "x(20)", "DR", "@"
    'item-doc-est.un', 'character', 'x(2)', "UN", "@"
    'item.doc-est.quantidade', 'decimal',    '99999999999999.99999', "QT", "@"
    'item-doc-est.preco-unit[1]', 'decimal', '999999999999999.99999', "VU", "@"
    'item-doc-est.preco-total', 'decimal',   '99999999999999.99999', "VR", "@"
    'item-doc-est.aliquota-ipi', 'decimal', '99999.99', "IP", "@"
    'item-doc-est.class-fiscal', 'character', 'x(14)', "CS", "@"
*/

/* AIM Exemplo do Manual
        SELF:SCREEN-VALUE = "IT11@NF011511@CE64534647000186@IE114.477.472.115@CF512@CD54444333001720@ID110970910119@NDFabricas de Sorvetes Doce Amor@DE210297@LP1@CP000001@ST10@DR PLACAMETALICA@CSA@QT4@VU100000@IC0@IP0@LP2@CP000002@ST20@DRIMPRESSORA@CSB@QT1@VU200000@IC0@IP0@LP3@CP000003@ST10@DRTERMINAL@CSB@QT1@VU100000@IC0@IP0@LP4@CP000005@ST10@DRCONCENTRADOR@CSB@QT1@VU200000@IC0@IP0@FP@BI0@UI0@VP0@VT900000@VN900000@QE02@ESVOLUME@RTTRANSPORTES ABC@DAMATERIAL SUJEITO A DEVOLUCAO NA DATA PREVISTA E EM PERFEITAS CONDICOES DE ARMAZENAMENTO@FT@":U.
*/
******************************************/

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME f-cgc
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL f-cgc wWindow
ON LEAVE OF f-cgc IN FRAME fpage0 /* CGC/CPF */
DO:
    DEF VAR i-cont AS INT.
    DEF VAR c-cgc-aux AS CHAR.
    DO  WITH FRAME fPage0:
        /* n∆o valida se nada foi digitado */
        IF  SELF:SCREEN-VALUE = "":U THEN
            RETURN.

        DO  i-cont  = 1 TO LENGTH(f-cgc:SCREEN-VALUE):
            IF index("1234567890",SUBSTRING(f-cgc:SCREEN-VALUE,i-cont,1)) > 0 
            THEN
                c-cgc-aux = c-cgc-aux + SUBSTRING(f-cgc:SCREEN-VALUE,i-cont,1).
        END.
        ASSIGN 
              f-cgc:SCREEN-VALUE = c-cgc-aux.

        /* Apenas valida o emitente sem cancelar a sa°da do campo */
        RUN validaEmitenteEtiqueta.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME f-nome-abrev
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL f-nome-abrev wWindow
ON LEAVE OF f-nome-abrev IN FRAME fpage0 /* Nome ou C¢digo */
DO:
    DO  WITH FRAME fPage0:
        /* n∆o valida se nada foi digitado */
        IF  SELF:SCREEN-VALUE = "":U THEN
            RETURN.

        /* Apenas valida o emitente sem cancelar a sa°da do campo */
        RUN validaEmitenteEtiqueta.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL f-nome-abrev wWindow
ON MOUSE-SELECT-DBLCLICK OF f-nome-abrev IN FRAME fpage0 /* Nome ou C¢digo */
DO:
    {include/zoomvar.i &prog-zoom=bcp/bc8203.w
                       &campo=f-nome-abrev
                       &campozoom=nome-abrev
                       &FRAME={&FRAME-NAME}
                       &campo2=f-nome-emit
                       &campozoom2=Nome-Emit
                       &FRAME2={&FRAME-NAME}}
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

    /* elimina instancia de DBOÔs */
    IF  VALID-HANDLE(hBOCL029) THEN
        DELETE PROCEDURE hBOCL029.

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

    DO  WITH FRAME fPage0:
        {utp/ut-liter.i "C¢digo 2D"}
        f-texto-nf:SCREEN-VALUE = " ":U + TRIM(RETURN-VALUE).

        ENABLE f-nome-abrev f-cgc ed-dados-nf.

        f-nome-abrev:LOAD-MOUSE-POINTER("image/lupa.cur":U).
        /*
        f-cgc:LOAD-MOUSE-POINTER("image/lupa.cur":U).
        */
    END.

    /* carrega DBOÔs */
    RUN clbo/bocl029.p PERSISTENT SET hBOCL029.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE processaDocumento wWindow 
PROCEDURE processaDocumento :
/*------------------------------------------------------------------------------
  Purpose:     Processamento principal da entrada de etiqueta 2D
               - Valida dados informados
               - Extrai informaá‰es da string
               - grava movimento no Coleta de Dados
  Parameters:  <none>
  Notes:       retorna OK ou NOK em return-value.
------------------------------------------------------------------------------*/


    &SCOPED-DEFINE CODTRANS2D   "Codigo2D"

    DEF VAR h-bcapi001      AS HANDLE    NO-UNDO.
    DEF VAR h-bcapi017      AS HANDLE    NO-UNDO.
    DEF VAR v-seq-filho     AS INTEGER   NO-UNDO.
    DEF VAR v-detalhe       AS CHARACTER NO-UNDO.
    DEF VAR v-num-versao    AS INTEGER   NO-UNDO.
    DEF VAR p-num-versao    AS INTEGER   NO-UNDO.
    DEF VAR h-acomp         AS HANDLE    NO-UNDO.

    /* verifica se string foi informada */
    IF  ed-dados-nf:SCREEN-VALUE IN FRAME fPage0 = "":U THEN DO:
        RUN utp/ut-msgs.p ("show":U, 25981, "").
        RETURN "NOK":U.
    END.

    /* valida os dados e obtem etiqueta do processo de entrada */
    RUN validaEmitenteEtiqueta.
    IF  RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.

    /* inicializa procedure de acompanhamento */
    SESSION:SET-WAIT-STATE("general":U).
    RUN utp/ut-acomp.p PERSISTENT SET h-acomp.
    {utp/ut-liter.i "Atualizando transaá∆o"}
    RUN pi-inicializar IN h-acomp (TRIM(RETURN-VALUE)).
    {utp/ut-liter.i "Decodificando Dados do Documento..."}
    RUN pi-acompanhar IN h-acomp (TRIM(RETURN-VALUE)).
    RUN pi-desabilita-cancela IN h-acomp.

    /* localiza dados do layout para uso adiante */
    RUN getDadosLayout IN hBOCL029 (OUTPUT f-cod-layout, OUTPUT tb-log-datasul, OUTPUT v-num-versao, OUTPUT f-descricao).

    /* Preparaá∆o dos dados */
    for each tt-campos EXCLUSIVE-LOCK:
        delete tt-campos.
    end.
    for each tt-erro EXCLUSIVE-LOCK:
        delete tt-erro.
    end.
    for each tt-trans EXCLUSIVE-LOCK:
        delete tt-trans.
    end.
    for each tt-trans-filho EXCLUSIVE-LOCK:
        delete tt-trans-filho.
    end.
    for each tt-xml EXCLUSIVE-LOCK:
        delete tt-xml.
    end.



    /* decodifica a string obtendo tt-campos */
    RUN bcp/bcapi019.p (f-nome-abrev:SCREEN-VALUE IN FRAME fPage0,
                        "",
                        ed-dados-nf:SCREEN-VALUE IN FRAME fPage0,
                        OUTPUT TABLE tt-campos,
                        OUTPUT TABLE tt-erro,
                        OUTPUT p-num-versao).
    IF  RETURN-VALUE = "NOK":U THEN DO:
        RUN cdp/cd0666.w (INPUT TABLE tt-erro).
        RUN pi-finalizar IN h-acomp.
        RETURN "NOK":U.
    END.

    ed-dados-nf = "".
    FOR EACH tt-campos NO-LOCK:
        ed-dados-nf = ed-dados-nf 
                    + "["
                    + STRING(tt-campos.segmento)
                    + "/"
                    + STRING(tt-campos.registro)
                    + "] "
                    + tt-campos.campo + '=' + tt-campos.valor + CHR(10).
    END.
    ed-dados-nf = ed-dados-nf + FILL("=", 80) + CHR(10).
    DISPLAY ed-dados-nf WITH FRAME fPage0.

    /* converte tt-campos para XML */
    {utp/ut-liter.i "Convertendo dados para XML..."}
    RUN pi-acompanhar IN h-acomp (TRIM(RETURN-VALUE)).

    RUN bcp/bcapi017.p PERSISTENT SET h-bcapi017.

    RUN geraXML IN h-bcapi017 (INPUT TABLE tt-campos, OUTPUT TABLE tt-xml).

    DELETE PROCEDURE h-bcapi017.

    /* Grava transaá∆o no Data Collection */
    {utp/ut-liter.i "Gerando Transaá∆o no Coleta de Dados..."}
    RUN pi-acompanhar IN h-acomp (TRIM(RETURN-VALUE)).

    /* geraá∆o do campo detalhe */
    v-detalhe = {&CODTRANS2D} + " -> ":U.
    {utp/ut-liter.i "Emitente"}
    v-detalhe = v-detalhe + TRIM(RETURN-VALUE) + ": ":U 
              + f-nome-abrev:SCREEN-VALUE IN FRAME fPage0
              + ", ":U.
    {utp/ut-liter.i "Tipo-Etiqueta"}
    v-detalhe = v-detalhe + TRIM(RETURN-VALUE) + ": ":U
              + f-tipo-etiq:SCREEN-VALUE IN FRAME fPage0
              + ", ":U.
    {utp/ut-liter.i "Layout"}
    v-detalhe = v-detalhe + TRIM(RETURN-VALUE) + ": ":U
              + STRING(f-cod-layout)
              + ", ":U.
    {utp/ut-liter.i "Padr∆o Datasul"}
    v-detalhe = v-detalhe + TRIM(RETURN-VALUE) + ": ":U
              + STRING(tb-log-datasul)
              + ", ":U.
    {utp/ut-liter.i "Vers∆o"}
    v-detalhe = v-detalhe + TRIM(RETURN-VALUE) + ": ":U
              + STRING(v-num-versao).

    ed-dados-nf = ed-dados-nf + CHR(10) + v-detalhe + CHR(10).

    /* geraá∆o dos dados para movimento pai (bc-trans) */
    CREATE tt-trans.
    ASSIGN tt-trans.cod-versao-integracao = 1
           tt-trans.i-sequen   = 1
           tt-trans.cd-trans   = {&CODTRANS2D}
           tt-trans.detalhe    = v-detalhe
           tt-trans.usuario    = c-seg-usuario
           tt-trans.atualizada = NO
           tt-trans.etiqueta   = NO.

    /* gera movimentos filhos (bc-trans-filho) */    
    FOR EACH tt-xml NO-LOCK: 
        v-seq-filho = v-seq-filho + 1.
        CREATE tt-trans-filho.
        ASSIGN tt-trans-filho.cod-versao-integracao = 1
               tt-trans-filho.i-sequen-pai = tt-trans.i-sequen
               tt-trans-filho.i-sequen     = v-seq-filho
               tt-trans-filho.tipo-etiq    = INTEGER(f-tipo-etiq:SCREEN-VALUE IN FRAME fPage0)
               tt-trans-filho.num-versao   = v-num-versao
               tt-trans-filho.segmento     = tt-xml.segmento
               tt-trans-filho.registro     = tt-xml.registro
               tt-trans-filho.conteudo-xml = tt-xml.conteudo.
        ed-dados-nf = ed-dados-nf + tt-xml.conteudo + CHR(10) + 
                      FILL("-", 80) + CHR(10).
    END.

    /* atualizaá∆o do movimento */
    /* Quando BCAPI001.P Ç executado "persistent" retorna sem gravar transaá∆o */
    /* obs: Ç preciso passar os parametros normalmente tt-trans e tt-erro */
    RUN bcp/bcapi001.p PERSISTENT SET h-bcapi001 (INPUT-OUTPUT TABLE tt-trans, 
                                                  INPUT-OUTPUT TABLE tt-erro).

    /* atualizaá∆o efetiva da transaá∆o */
    RUN atualizaTransacao IN h-bcapi001 (INPUT-OUTPUT TABLE tt-trans, 
                                         INPUT-OUTPUT TABLE tt-trans-ext,
                                         INPUT-OUTPUT TABLE tt-trans-filho,
                                         INPUT-OUTPUT TABLE tt-erro).

    DELETE PROCEDURE h-bcapi001.

    /* fim do acompanhamento */
    RUN pi-finalizar IN h-acomp.
    SESSION:SET-WAIT-STATE("":U).  

    DISPLAY ed-dados-nf WITH FRAME fPage0.

    FIND FIRST tt-erro NO-LOCK NO-ERROR.
    IF  AVAIL tt-erro THEN DO:
        RUN cdp/cd0666.w (INPUT TABLE tt-erro).
        RETURN "NOK":U.
    END.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validaEmitenteEtiqueta wWindow 
PROCEDURE validaEmitenteEtiqueta :
/*------------------------------------------------------------------------------
  Purpose:     verifica se o emiente existe e possui bc-emitente-etiqueta
  Parameters:  <none>
  Notes:       retorna OK ou NOK em return-value
               retorna a etiqueta do emitente para o processo de entrada.
------------------------------------------------------------------------------*/

    DEF VAR v-cod-emitente          AS INTEGER NO-UNDO.
    DEF VAR v-num-versao            AS INTEGER NO-UNDO.


    DO  WITH FRAME fPage0:
        /* le emitente para validar e buscar nome-emit */

        run pi-verifica-emitente    ( input f-nome-abrev:SCREEN-VALUE in frame {&FRAME-NAME},
                                      input f-nome-abrev:SCREEN-VALUE in frame {&FRAME-NAME},
                                      input 0,    /* Codigo do Emitente               */
                                      input 0,    /* Codigo do Emitente               */
                                      input 5,    /* Tipo de Acesso 0=Currente ....   */
                                      input 2).   /* Record-Frase = 2 (cgc)*/

        if  NOT AVAIL ttemitente THEN DO:
            v-cod-emitente = INTEGER(f-nome-abrev:SCREEN-VALUE) NO-ERROR.

            IF  v-cod-emitente > 0 THEN DO:

                run pi-verifica-emitente    ( input "",
                                              input "",
                                              input v-cod-emitente,    /* Codigo do Emitente               */
                                              input v-cod-emitente,    /* Codigo do Emitente               */
                                              input 5,    /* Tipo de Acesso 0=Currente ....   */
                                              input 2).   /* Record-Frase = 2 (cgc)*/


            END.

        END.

        /* tenta ler pelo cgc - em base de teste tem emitente com nome-abrev = "" */
        IF  (NOT AVAIL ttemitente OR f-nome-abrev:SCREEN-VALUE = "":U)
        AND f-cgc:SCREEN-VALUE <> "":U THEN DO:

            run pi-verifica-emitentecgc ( input f-cgc:SCREEN-VALUE in frame {&FRAME-NAME},
                                          input f-cgc:SCREEN-VALUE in frame {&FRAME-NAME},
                                          input 0,    /* Codigo do Emitente               */
                                          input 0,    /* Codigo do Emitente               */
                                          input 5,    /* Tipo de Acesso 0=Currente ....   */
                                          input 2, "", "").   /* Record-Frase = 2 (cgc)*/

            IF  NOT AVAIL ttemitentecgc
            THEN DO:
                RUN utp/ut-msgs.p ("show":U, 25947, f-cgc:SCREEN-VALUE).
                RETURN "NOK":U.
            END.

            f-nome-abrev:SCREEN-VALUE = ttemitentecgc.nome-abrev.
            f-nome-emit:SCREEN-VALUE  = ttemitentecgc.nome-emit.
            f-cgc:SCREEN-VALUE        = ttemitentecgc.cgc.

        END.

        IF  NOT AVAIL ttemitente 
        AND NOT AVAIL ttemitentecgc
        THEN DO:
            {utp/ut-table.i mgadm emitente 1}
            RUN utp/ut-msgs.p ("show":U, 2, RETURN-VALUE).
            RETURN "NOK":U.
        END.


        IF  AVAIL ttemitente THEN DO:

            f-nome-abrev:SCREEN-VALUE = ttemitente.nome-abrev.
            f-nome-emit:SCREEN-VALUE  = ttemitente.nome-emit.

            run pi-verifica-emitentecgc ( input "",
                                          input "",
                                          input ttemitente.cod-emitente,    /* Codigo do Emitente               */
                                          input ttemitente.cod-emitente,    /* Codigo do Emitente               */
                                          input 5,    /* Tipo de Acesso 0=Currente ....   */
                                          input 1, "", "").   /* Record-Frase = 2 (cgc)*/

            IF  AVAIL ttemitentecgc THEN DO:
                f-cgc:SCREEN-VALUE        = ttemitentecgc.cgc.
            END.

        END.

        /* le bc-emitente-etiqueta para ver se emitente possui parametro para 2d */
        RUN OpenQueryStatic IN hBOCL029 ("Main":U).
        RUN gotoKey IN hBOCL029 (1 /* entrada */, f-nome-abrev:SCREEN-VALUE).
        IF  RETURN-VALUE = "NOK":U THEN DO:
            RUN utp/ut-msgs.p ("show":U, 25934, f-nome-abrev:SCREEN-VALUE).
            RETURN "NOK":U.
        END.
        RUN getIntField IN hBOCL029 ("tipo-etiq":U, OUTPUT f-tipo-etiq).
        DISPLAY f-tipo-etiq.
        RUN getDadosLayout IN hBOCL029 (OUTPUT f-cod-layout, OUTPUT tb-log-datasul, OUTPUT v-num-versao, OUTPUT f-descricao).
        DISPLAY f-cod-layout
                tb-log-datasul
                f-descricao.
    END.
    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

