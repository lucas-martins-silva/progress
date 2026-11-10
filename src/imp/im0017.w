&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          mgadm            PROGRESS
          mgcex            PROGRESS
          mguni            PROGRESS
*/
&Scoped-define WINDOW-NAME wReport
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS wReport 
/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i IM0017 2.00.00.013} /*** "010013" 03/09/2024 10:50:12 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i im0017 MIM}
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

{include/i_dbvers.i} /*Include de Pr‚-Processadores*/

&IF '{&mgdis_version}' < '2.06f' &THEN
    /*Tecnica para implementar validação produto Estendido*/
    {cdp/cdapi558.i &ProdutoEstendido=20 &ModuloEstendido=MIM}
&endif
/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program        IM0017
&GLOBAL-DEFINE Version        2.00.00.013
&GLOBAL-DEFINE VersionLayout  <VersionLayout>

&GLOBAL-DEFINE Folder         YES
&GLOBAL-DEFINE InitialPage    1
&GLOBAL-DEFINE FolderLabels   Despesa

&GLOBAL-DEFINE PGLAY          NO
&GLOBAL-DEFINE PGSEL          YES
&GLOBAL-DEFINE PGCLA          NO
&GLOBAL-DEFINE PGPAR          NO
&GLOBAL-DEFINE PGDIG          NO
&GLOBAL-DEFINE PGIMP          NO
&GLOBAL-DEFINE PGLOG          NO

&GLOBAL-DEFINE RTF            NO

&GLOBAL-DEFINE page0Widgets   btOk btCancel btHelp2 btSelecao
&GLOBAL-DEFINE page2Widgets   
&GLOBAL-DEFINE page0Text      
&GLOBAL-DEFINE page2Text      


&GLOBAL-DEFINE page2Fields    i-cod-desp i-cod-emitente-desp i-mo-codigo ~
                              i-cod-cond-pag i-cod-pto-contr i-tp-despesa ~
                              c-cod-incoterm-rat de-val-desp rs-opcao

/* Local Variable Definitions ---                                       */
DEFINE VARIABLE h-boad039     AS HANDLE     NO-UNDO.
DEFINE VARIABLE h-boad259     AS HANDLE     NO-UNDO.
DEFINE VARIABLE h-bocx095     AS HANDLE     NO-UNDO.
DEFINE VARIABLE h-bocx110     AS HANDLE     NO-UNDO.
DEFINE VARIABLE h-bocx341     AS HANDLE     NO-UNDO.
DEFINE VARIABLE h-boin295desc AS HANDLE     NO-UNDO.
DEFINE VARIABLE h-boun005     AS HANDLE     NO-UNDO.
DEFINE VARIABLE h-im0017a     AS HANDLE     NO-UNDO.
DEFINE VARIABLE h-bocx155     AS HANDLE     NO-UNDO.
DEFINE VARIABLE h-boad098na   AS HANDLE     NO-UNDO.

DEFINE VARIABLE c-cgc         AS CHARACTER  NO-UNDO.
DEFINE VARIABLE c-retorno     AS CHARACTER  NO-UNDO.
DEFINE VARIABLE l-imposto     AS LOGICAL    NO-UNDO.
DEFINE VARIABLE c-cod-estabel AS CHARACTER  NO-UNDO.
DEFINE VARIABLE i-sequencia   AS INTEGER    NO-UNDO.
DEFINE VARIABLE c-erro        AS CHARACTER NO-UNDO.
DEFINE VARIABLE c-advertencia AS CHARACTER NO-UNDO.
DEFINE VARIABLE l-despesa-disponivel AS LOGICAL NO-UNDO.
DEFINE VARIABLE rw-despes-ped-compra AS ROWID NO-UNDO.

DEFINE NEW GLOBAL SHARED VARIABLE adm-broker-hdl AS HANDLE  NO-UNDO.

DEFINE TEMP-TABLE tt-pedido NO-UNDO
    FIELD marca           AS LOGICAL
    FIELD num-pedido      LIKE pedido-compr.num-pedido
    FIELD cod-emitente    LIKE pedido-compr.cod-emitente
    FIELD nome-abrev      LIKE emitente.nome-abrev
    FIELD data-pedido     LIKE pedido-compr.data-pedido
    FIELD nr-proc-imp     LIKE processo-imp.nr-proc-imp
    FIELD incoterm        AS CHARACTER
    FIELD cod-itiner      LIKE itinerario.cod-itiner
    FIELD desc-itiner     LIKE itinerario.descricao
    FIELD val-desp        LIKE despes-ped-compra.val-desp
    FIELD log-execucao-OK AS LOGICAL
    FIELD r-rowid         AS ROWID.

DEFINE TEMP-TABLE tt-param NO-UNDO
&IF "{&mguni_version}" >= "2.071" &THEN
    FIELD cod-estabel                    AS CHARACTER format "x(05)"
&ELSE
    FIELD cod-estabel                    AS CHARACTER FORMAT "x(03)"
&ENDIF
    FIELD num-pedido-ini                 AS INTEGER   FORMAT ">>>>>,>>9"
    FIELD num-pedido-fim                 AS INTEGER   FORMAT ">>>>>,>>9"
    FIELD data-pedido-ini                AS DATE      FORMAT "99/99/9999"
    FIELD data-pedido-fim                AS DATE      FORMAT "99/99/9999"
    FIELD via-transp-ini                 AS INTEGER   FORMAT "9"
    FIELD via-transp-fim                 AS INTEGER   FORMAT "9"
    FIELD cod-transp-ini                 AS INTEGER   FORMAT ">>,>>9"
    FIELD cod-transp-fim                 AS INTEGER   FORMAT ">>,>>9"
    FIELD cod-emitente-ini               AS INTEGER   FORMAT ">>>>>>>>9"
    FIELD cod-emitente-fim               AS INTEGER   FORMAT ">>>>>>>>9"
    FIELD nr-proc-imp-ini                AS CHARACTER FORMAT "x(12)"
    FIELD nr-proc-imp-fim                AS CHARACTER FORMAT "x(12)"
    FIELD incoterm-ini                   AS CHARACTER FORMAT "x(03)"
    FIELD incoterm-fim                   AS CHARACTER FORMAT "x(03)"
    FIELD cod-itiner-ini                 AS INTEGER   FORMAT ">>,>>9"
    FIELD cod-itiner-fim                 AS INTEGER   FORMAT ">>,>>9"
    FIELD cod-despachante-ini            AS INTEGER   FORMAT ">>>>>>>>9"
    FIELD cod-despachante-fim            AS INTEGER   FORMAT ">>>>>>>>9"
    FIELD cdn-despa-exter-import-ini     AS INTEGER   FORMAT ">>>>>>>>9"
    FIELD cdn-despa-exter-import-fim     AS INTEGER   FORMAT ">>>>>>>>9"
    FIELD cdn-corretor-cambio-import-ini AS INTEGER   FORMAT ">>>>>>>>9"
    FIELD cdn-corretor-cambio-import-fim AS INTEGER   FORMAT ">>>>>>>>9"
    FIELD cod-agente-ini                 AS INTEGER   FORMAT ">>>>>>>>9"
    FIELD cod-agente-fim                 AS INTEGER   FORMAT ">>>>>>>>9"
    FIELD cdn-segurad-import-ini         AS INTEGER   FORMAT ">>>>>>>>9"
    FIELD cdn-segurad-import-fim         AS INTEGER   FORMAT ">>>>>>>>9"
    FIELD cdn-corretor-import-ini        AS INTEGER   FORMAT ">>>>>>>>9"
    FIELD cdn-corretor-import-fim        AS INTEGER   FORMAT ">>>>>>>>9"
    FIELD it-codigo-ini                  AS CHARACTER FORMAT "x(16)"
    FIELD it-codigo-fim                  AS CHARACTER FORMAT "x(16)".

DEFINE TEMP-TABLE tt-num-pedidos NO-UNDO
    FIELD num-pedido          LIKE despes-ped-compra.num-pedido.

DEFINE TEMP-TABLE tt-despesa NO-UNDO
    FIELD cod-desp          AS INTEGER   FORMAT ">>,>>9"
    FIELD desc-desp         AS CHARACTER FORMAT "x(30)"
    FIELD cod-emitente-desp AS INTEGER   FORMAT ">>>>>>>>9"
    FIELD desc-emitente     AS CHARACTER FORMAT "x(12)"
    FIELD mo-codigo         AS INTEGER   FORMAT ">9"
    FIELD desc-moeda        AS CHARACTER FORMAT "x(12)"
    FIELD cod-cond-pag      AS INTEGER   FORMAT ">>>9"
    FIELD desc-cond-pag     AS CHARACTER FORMAT "x(30)"
    FIELD cod-pto-contr     AS INTEGER   FORMAT ">>,>>9"
    FIELD desc-pto-contr    AS CHARACTER FORMAT "x(30)"
    FIELD tp-despesa        AS INTEGER   FORMAT ">>9"
    FIELD desc-tipo-despesa AS CHARACTER FORMAT "x(30)"
    FIELD cod-incoterm-rat  AS CHARACTER FORMAT "x(03)"
    FIELD val-desp          AS DECIMAL   FORMAT ">>>>>,>>>,>>9.99"
    FIELD opcao             AS INTEGER.

DEF TEMP-TABLE tt-desp-param NO-UNDO
    FIELD cod-desp          LIKE desp-imp.cod-desp
    FIELD val-desp          LIKE despes-ped-compra.val-desp
    FIELD mo-codigo         LIKE despes-ped-compra.mo-codigo
    FIELD cod-emitente-desp LIKE despes-ped-compra.cod-emitente-desp
    FIELD cod-cond-pag      LIKE despes-ped-compra.cod-cond-pag
    FIELD cod-pto-contr     LIKE despes-ped-compra.cod-pto-contr
    FIELD cod-incoterm-rat  LIKE despes-ped-compra.cod-incoterm-rat
    FIELD tp-despesa        LIKE despes-ped-compra.tp-despesa.

DEFINE TEMP-TABLE tt-despes-ped-compra  NO-UNDO LIKE despes-ped-compra
    FIELD r-rowid AS ROWID.

DEFINE TEMP-TABLE tt-erro NO-UNDO
    FIELD codigo    AS INTEGER   FORMAT "ZZ,ZZ9":U
    FIELD tipo      AS CHARACTER FORMAT "X(011)":U
    FIELD descricao AS CHARACTER FORMAT "X(113)":U.

DEFINE BUFFER bf-despes-ped-compra FOR despes-ped-compra.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fpage0

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS rtToolBar btOK btCancel btSelecao btHelp2 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR wReport AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON btCancel 
     LABEL "&Fechar" 
     SIZE 10 BY 1.

DEFINE BUTTON btHelp2 
     LABEL "&Ajuda" 
     SIZE 10 BY 1.

DEFINE BUTTON btOK 
     LABEL "&Executar" 
     SIZE 10 BY 1.

DEFINE BUTTON btSelecao 
     IMAGE-UP FILE "image~\ii-ran.bmp":U
     LABEL "Sele‡Æo de Pedidos" 
     SIZE 4 BY 1 TOOLTIP "Seleciona Pedidos"
     FONT 4.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE  
     SIZE 90 BY 1.42
     BGCOLOR 7 .

DEFINE VARIABLE c-cod-incoterm-rat AS CHARACTER FORMAT "x(3)" 
     LABEL "Incoterm de Rateio":R22 
     VIEW-AS FILL-IN 
     SIZE 5 BY .88 NO-UNDO.

DEFINE VARIABLE c-desc-cond-pagto LIKE cond-pagto.descricao
     VIEW-AS FILL-IN 
     SIZE 32 BY .88 NO-UNDO.

DEFINE VARIABLE c-desc-desp AS CHARACTER FORMAT "X(30)":U 
     VIEW-AS FILL-IN 
     SIZE 32 BY .88 NO-UNDO.

DEFINE VARIABLE c-desc-emit AS CHARACTER FORMAT "X(12)":U 
     VIEW-AS FILL-IN 
     SIZE 28 BY .88 NO-UNDO.

DEFINE VARIABLE c-desc-moeda LIKE moeda.descricao
     VIEW-AS FILL-IN 
     SIZE 13 BY .88 NO-UNDO.

DEFINE VARIABLE c-desc-pto-contr LIKE pto-contr.descricao
     VIEW-AS FILL-IN 
     SIZE 31 BY .88 NO-UNDO.

DEFINE VARIABLE c-desc-tipo-despesa LIKE desp-imp.descricao
     VIEW-AS FILL-IN 
     SIZE 33 BY .88 NO-UNDO.

DEFINE VARIABLE de-val-desp AS DECIMAL FORMAT ">>>>>,>>>,>>9.99999" INITIAL 0 
     LABEL "Valor Despesa":R16 
     VIEW-AS FILL-IN 
     SIZE 21 BY .88 NO-UNDO.

DEFINE VARIABLE i-cod-cond-pag AS INTEGER FORMAT ">>>9" INITIAL 0 
     LABEL "Condi‡Æo Pagamento":R22 
     VIEW-AS FILL-IN 
     SIZE 6 BY .88 NO-UNDO.

DEFINE VARIABLE i-cod-desp AS INTEGER FORMAT ">>,>>9" INITIAL 0 
     LABEL "C¢digo Despesa":R17 
     VIEW-AS FILL-IN 
     SIZE 6 BY .88 NO-UNDO.

DEFINE VARIABLE i-cod-emitente-desp AS INTEGER FORMAT ">>>>>>>>9" INITIAL 0 
     LABEL "Fornec Despesa":R17 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88 NO-UNDO.

DEFINE VARIABLE i-cod-pto-contr AS INTEGER FORMAT ">>,>>9" INITIAL 0 
     LABEL "Ponto Controle":R17 
     VIEW-AS FILL-IN 
     SIZE 7 BY .88 NO-UNDO.

DEFINE VARIABLE i-mo-codigo AS INTEGER FORMAT ">9" INITIAL 0 
     LABEL "C¢digo Moeda":R15 
     VIEW-AS FILL-IN 
     SIZE 4 BY .88 NO-UNDO.

DEFINE VARIABLE i-tp-despesa AS INTEGER FORMAT ">>9" INITIAL 0 
     LABEL "Tipo Despesa":R15 
     VIEW-AS FILL-IN 
     SIZE 5 BY .88 NO-UNDO.

DEFINE VARIABLE rs-opcao AS INTEGER 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "Incluir", 1,
"Eliminar", 2
     SIZE 26 BY 1.25 NO-UNDO.

DEFINE RECTANGLE RECT-2
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 84 BY 12.25.

DEFINE RECTANGLE RECT-3
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 80 BY 9.

DEFINE RECTANGLE RECT-4
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 80 BY 1.75.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fpage0
     btOK AT ROW 16.5 COL 2
     btCancel AT ROW 16.5 COL 13
     btSelecao AT ROW 16.5 COL 75 HELP
          "Consultas relacionadas"
     btHelp2 AT ROW 16.5 COL 80
     rtToolBar AT ROW 16.25 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 90 BY 16.67
         FONT 1.

DEFINE FRAME fPage2
     i-cod-desp AT ROW 2.25 COL 30 COLON-ALIGNED HELP
          "C¢digo da Despesa/Imposto."
     c-desc-desp AT ROW 2.25 COL 36 COLON-ALIGNED NO-LABEL
     i-cod-emitente-desp AT ROW 3.25 COL 30 COLON-ALIGNED HELP
          "C¢digo do Fornecedor da Despesa/Imposto"
     c-desc-emit AT ROW 3.25 COL 40 COLON-ALIGNED NO-LABEL
     i-mo-codigo AT ROW 4.25 COL 30 COLON-ALIGNED HELP
          "C¢digo da moeda"
     c-desc-moeda AT ROW 4.25 COL 34 COLON-ALIGNED HELP
          "" NO-LABEL
     i-cod-cond-pag AT ROW 5.25 COL 30 COLON-ALIGNED HELP
          "C¢digo da condi‡Æo de pagamento"
     c-desc-cond-pagto AT ROW 5.25 COL 36 COLON-ALIGNED HELP
          "" NO-LABEL
     i-cod-pto-contr AT ROW 6.25 COL 30 COLON-ALIGNED HELP
          "C¢digo do Ponto de Controle."
     c-desc-pto-contr AT ROW 6.25 COL 37 COLON-ALIGNED HELP
          "" NO-LABEL
     i-tp-despesa AT ROW 7.25 COL 30 COLON-ALIGNED HELP
          "Tipo de despesa da Compra."
     c-desc-tipo-despesa AT ROW 7.25 COL 35 COLON-ALIGNED HELP
          "" NO-LABEL
     c-cod-incoterm-rat AT ROW 8.25 COL 30 COLON-ALIGNED HELP
          "Incoterm de Rateio"
     de-val-desp AT ROW 9.25 COL 30 COLON-ALIGNED HELP
          "Valor da Despesa/Imposto"
     rs-opcao AT ROW 11.5 COL 30 NO-LABEL
     RECT-2 AT ROW 1.25 COL 1.14
     RECT-3 AT ROW 1.75 COL 3
     RECT-4 AT ROW 11.25 COL 3
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.57 ROW 2.5
         SIZE 84.43 BY 12.75
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
  CREATE WINDOW wReport ASSIGN
         HIDDEN             = YES
         TITLE              = ""
         HEIGHT             = 16.67
         WIDTH              = 90
         MAX-HEIGHT         = 22
         MAX-WIDTH          = 114.14
         VIRTUAL-HEIGHT     = 22
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB wReport 
/* ************************* Included-Libraries *********************** */

{report~/report.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW wReport
  NOT-VISIBLE,,RUN-PERSISTENT                                           */
/* REPARENT FRAME */
ASSIGN FRAME fPage2:FRAME = FRAME fpage0:HANDLE.

/* SETTINGS FOR FRAME fpage0
   NOT-VISIBLE FRAME-NAME                                               */
/* SETTINGS FOR FRAME fPage2
                                                                        */
/* SETTINGS FOR FILL-IN c-desc-cond-pagto IN FRAME fPage2
   NO-ENABLE LIKE = mgadm.cond-pagto.descricao EXP-SIZE                 */
/* SETTINGS FOR FILL-IN c-desc-desp IN FRAME fPage2
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-desc-emit IN FRAME fPage2
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-desc-moeda IN FRAME fPage2
   NO-ENABLE LIKE = mguni.moeda.descricao EXP-LABEL EXP-SIZE            */
/* SETTINGS FOR FILL-IN c-desc-pto-contr IN FRAME fPage2
   NO-ENABLE LIKE = mgcex.pto-contr.descricao EXP-LABEL EXP-SIZE        */
/* SETTINGS FOR FILL-IN c-desc-tipo-despesa IN FRAME fPage2
   NO-ENABLE LIKE = mgcex.desp-imp.descricao EXP-LABEL EXP-SIZE         */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wReport)
THEN wReport:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME fpage0
/* Query rebuild information for FRAME fpage0
     _Options          = "SHARE-LOCK KEEP-EMPTY"
     _Query            is NOT OPENED
*/  /* FRAME fpage0 */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME fPage2
/* Query rebuild information for FRAME fPage2
     _Query            is NOT OPENED
*/  /* FRAME fPage2 */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME wReport
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wReport wReport
ON END-ERROR OF wReport
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wReport wReport
ON WINDOW-CLOSE OF wReport
DO:
  /* This event will close the window and terminate the procedure.  */
  {report/logfin.i}  
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btCancel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btCancel wReport
ON CHOOSE OF btCancel IN FRAME fpage0 /* Fechar */
DO:
    APPLY "CLOSE":U TO THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btHelp2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btHelp2 wReport
ON CHOOSE OF btHelp2 IN FRAME fpage0 /* Ajuda */
DO:
    {include/ajuda.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btOK
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btOK wReport
ON CHOOSE OF btOK IN FRAME fpage0 /* Executar */
DO:
   do  on error undo, return no-apply:
       run piExecute.
   end.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btSelecao
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btSelecao wReport
ON CHOOSE OF btSelecao IN FRAME fpage0 /* Sele‡Æo de Pedidos */
DO:
    ASSIGN {&WINDOW-NAME}:SENSITIVE = NO.

    IF  NOT VALID-HANDLE(h-im0017a) THEN
        RUN imp/im0017a.w PERSISTENT SET h-im0017a (INPUT THIS-PROCEDURE).

    RUN setSelecao   IN h-im0017a (INPUT TABLE tt-param).
    RUN setTempTable IN h-im0017a (INPUT TABLE tt-pedido,
                                   INPUT c-cod-estabel).

    RUN initializeInterface IN h-im0017a.

    WAIT-FOR CLOSE OF h-im0017a FOCUS CURRENT-WINDOW.

    ASSIGN {&WINDOW-NAME}:SENSITIVE = YES.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage2
&Scoped-define SELF-NAME c-cod-incoterm-rat
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-cod-incoterm-rat wReport
ON F5 OF c-cod-incoterm-rat IN FRAME fPage2 /* Incoterm de Rateio */
DO:
    {method/zoomfields.i &ProgramZoom  = "cxzoom/z10cx025.w"
                                        &FieldZoom1   = cod-incoterm
                                        &FieldScreen1 = c-cod-incoterm-rat
                                        &Frame1       = fPage2}  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-cod-incoterm-rat wReport
ON MOUSE-SELECT-DBLCLICK OF c-cod-incoterm-rat IN FRAME fPage2 /* Incoterm de Rateio */
DO:
    APPLY "F5" TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME i-cod-cond-pag
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i-cod-cond-pag wReport
ON F5 OF i-cod-cond-pag IN FRAME fPage2 /* Condi‡Æo Pagamento */
DO:
    {include/zoomvar.i &prog-zoom = adzoom/z01ad039.w
                       &campo=i-cod-cond-pag
                       &campozoom=cod-cond-pag
                       &campo2=c-desc-cond-pagto
                       &campozoom2=descricao
                       &FRAME = "fPage2"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i-cod-cond-pag wReport
ON LEAVE OF i-cod-cond-pag IN FRAME fPage2 /* Condi‡Æo Pagamento */
DO:
    RUN findCodigo IN h-boad039 (INPUT  i-cod-cond-pag:SCREEN-VALUE IN FRAME fPage2,
                                 OUTPUT c-retorno).
    IF c-retorno = "" THEN
        RUN getCharField IN h-boad039 (INPUT  "descricao",
                                       OUTPUT c-desc-cond-pagto).
    ELSE 
        ASSIGN c-desc-cond-pagto = "".

    ASSIGN c-desc-cond-pagto:SCREEN-VALUE IN FRAME fPage2 = c-desc-cond-pagto.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i-cod-cond-pag wReport
ON MOUSE-SELECT-DBLCLICK OF i-cod-cond-pag IN FRAME fPage2 /* Condi‡Æo Pagamento */
DO:
    APPLY "F5" TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME i-cod-desp
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i-cod-desp wReport
ON F5 OF i-cod-desp IN FRAME fPage2 /* C¢digo Despesa */
DO:
    {include/zoomvar.i &prog-zoom = cxzoom/z01cx095.w
                       &campo=i-cod-desp
                       &campozoom=cod-desp
                       &campo2=c-desc-desp
                       &campozoom2=descricao
                       &FRAME = "fPage2"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i-cod-desp wReport
ON LEAVE OF i-cod-desp IN FRAME fPage2 /* C¢digo Despesa */
DO:
    RUN pi-leaveDespesa IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i-cod-desp wReport
ON MOUSE-SELECT-DBLCLICK OF i-cod-desp IN FRAME fPage2 /* C¢digo Despesa */
DO:
    APPLY "F5" TO SELF.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME i-cod-emitente-desp
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i-cod-emitente-desp wReport
ON F5 OF i-cod-emitente-desp IN FRAME fPage2 /* Fornec Despesa */
DO:
    {include/zoomvar.i &prog-zoom = adzoom/z03ad098.w
                       &campo=i-cod-emitente-desp
                       &campozoom=cod-emitente
                       &campo2=c-desc-emit
                       &campozoom2=nome-abrev
                       &FRAME = "fPage2"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i-cod-emitente-desp wReport
ON LEAVE OF i-cod-emitente-desp IN FRAME fPage2 /* Fornec Despesa */
DO:
    RUN getDescCgcEmitente  IN h-boin295desc (INPUT  i-cod-emitente-desp:SCREEN-VALUE IN FRAME fPage2,
                                              OUTPUT c-desc-emit,
                                              OUTPUT c-cgc).
    ASSIGN c-desc-emit:SCREEN-VALUE IN FRAME fPage2 = c-desc-emit.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i-cod-emitente-desp wReport
ON MOUSE-SELECT-DBLCLICK OF i-cod-emitente-desp IN FRAME fPage2 /* Fornec Despesa */
DO:
    APPLY "F5" TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME i-cod-pto-contr
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i-cod-pto-contr wReport
ON F5 OF i-cod-pto-contr IN FRAME fPage2 /* Ponto Controle */
DO:
    {include/zoomvar.i &prog-zoom = cxzoom/z01cx120.w
                       &campo=i-cod-pto-contr
                       &campozoom=cod-pto-contr
                       &FRAME = "fPage2"} 
                       
    WAIT-FOR CLOSE OF wh-pesquisa.
    APPLY "leave" TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i-cod-pto-contr wReport
ON LEAVE OF i-cod-pto-contr IN FRAME fPage2 /* Ponto Controle */
DO:
    RUN retornaDescricao IN h-bocx110 (INPUT  i-cod-pto-contr:SCREEN-VALUE IN FRAME fPage2,
                                       OUTPUT c-desc-pto-contr).

    ASSIGN c-desc-pto-contr:SCREEN-VALUE IN FRAME fPage2 = c-desc-pto-contr.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i-cod-pto-contr wReport
ON MOUSE-SELECT-DBLCLICK OF i-cod-pto-contr IN FRAME fPage2 /* Ponto Controle */
DO:
    APPLY "F5" TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME i-mo-codigo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i-mo-codigo wReport
ON F5 OF i-mo-codigo IN FRAME fPage2 /* C¢digo Moeda */
DO:
    {include/zoomvar.i &prog-zoom = adzoom/z01ad178.w
                       &campo=i-mo-codigo
                       &campozoom=mo-codigo
                       &campo2=c-desc-moeda
                       &campozoom2=descricao
                       &FRAME = "fPage2"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i-mo-codigo wReport
ON LEAVE OF i-mo-codigo IN FRAME fPage2 /* C¢digo Moeda */
DO:
    RUN findCodigo IN h-boun005 (INPUT  i-mo-codigo:SCREEN-VALUE IN FRAME fPage2,
                                 OUTPUT c-retorno).
    IF c-retorno = "" THEN
        RUN getCharField IN h-boun005(INPUT  "descricao",
                                      OUTPUT c-desc-moeda).
    ELSE
        ASSIGN c-desc-moeda = "".

    ASSIGN c-desc-moeda:SCREEN-VALUE IN FRAME fPage2 = c-desc-moeda.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i-mo-codigo wReport
ON MOUSE-SELECT-DBLCLICK OF i-mo-codigo IN FRAME fPage2 /* C¢digo Moeda */
DO:
    APPLY "F5" TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME i-tp-despesa
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i-tp-despesa wReport
ON F5 OF i-tp-despesa IN FRAME fPage2 /* Tipo Despesa */
DO:
    {include/zoomvar.i &prog-zoom = adzoom/z01ad259.w
                       &campo=i-tp-despesa
                       &campozoom=tp-codigo
                       &campo2=c-desc-tipo-despesa
                       &campozoom2=descricao
                       &FRAME = "fPage2"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i-tp-despesa wReport
ON LEAVE OF i-tp-despesa IN FRAME fPage2 /* Tipo Despesa */
DO:
    RUN findCodigo IN h-boad259 (INPUT  i-tp-despesa:SCREEN-VALUE IN FRAME fPage2,
                                 OUTPUT c-retorno).
    IF c-retorno = "" THEN
        RUN getCharField IN h-boad259 (INPUT  "descricao",
                                       OUTPUT c-desc-tipo-despesa).
    ELSE
        ASSIGN c-desc-tipo-despesa = "".
    
    ASSIGN c-desc-tipo-despesa:SCREEN-VALUE IN FRAME fPage2 = c-desc-tipo-despesa.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i-tp-despesa wReport
ON MOUSE-SELECT-DBLCLICK OF i-tp-despesa IN FRAME fPage2 /* Tipo Despesa */
DO:
    APPLY "F5" TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME rs-opcao
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL rs-opcao wReport
ON VALUE-CHANGED OF rs-opcao IN FRAME fPage2
DO:
    /* Eliminar? */
    IF  INPUT FRAME fPage2 rs-opcao = 2 THEN DO:
        ASSIGN de-val-desp:SENSITIVE           IN FRAME fPage2 = NO
               c-cod-incoterm-rat:SENSITIVE    IN FRAME fPage2 = NO
               de-val-desp:SCREEN-VALUE        IN FRAME fPage2 = "":U
               c-cod-incoterm-rat:SCREEN-VALUE IN FRAME fPage2 = "":U.
    END.
    ELSE DO:
        RUN pi-incoterm IN THIS-PROCEDURE.

        IF l-imposto THEN DO:
            ASSIGN de-val-desp:SENSITIVE    IN FRAME fPage2 = NO
                   de-val-desp:SCREEN-VALUE IN FRAME fPage2 = STRING(0).
            RUN utp/ut-msgs.p (INPUT "Show":U, INPUT 32051,"").
        END.
        ELSE
            ASSIGN de-val-desp:SENSITIVE IN FRAME fPage2 = YES.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fpage0
&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wReport 


/*:T--- L¢gica para inicializa‡Æo do programam ---*/
{report/mainblock.i}

i-cod-desp:LOAD-MOUSE-POINTER("image/lupa.cur":U) IN FRAME fPage2.
i-cod-emitente-desp:LOAD-MOUSE-POINTER("image/lupa.cur":U) IN FRAME fPage2.
i-mo-codigo:LOAD-MOUSE-POINTER("image/lupa.cur":U) IN FRAME fPage2.
i-cod-cond-pag:LOAD-MOUSE-POINTER("image/lupa.cur":U) IN FRAME fPage2.
i-cod-pto-contr:LOAD-MOUSE-POINTER("image/lupa.cur":U) IN FRAME fPage2.
i-tp-despesa:LOAD-MOUSE-POINTER("image/lupa.cur":U) IN FRAME fPage2.
c-cod-incoterm-rat:LOAD-MOUSE-POINTER("image/lupa.cur":U) IN FRAME fPage2.

{utp/ut-liter.i Erro * r}
ASSIGN c-erro = TRIM(RETURN-VALUE).

{utp/ut-liter.i Advertˆncia * r}
ASSIGN c-advertencia = TRIM(RETURN-VALUE).

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterDestroyInterface wReport 
PROCEDURE afterDestroyInterface :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    IF  VALID-HANDLE(h-boad039) THEN 
        DELETE PROCEDURE h-boad039.
    ASSIGN h-boad039 = ?.
    
    IF  VALID-HANDLE(h-boad259) THEN 
        DELETE PROCEDURE h-boad259.
    ASSIGN h-boad259 = ?.
    
    IF  VALID-HANDLE(h-bocx095) THEN
        DELETE PROCEDURE h-bocx095.
    ASSIGN h-bocx095 = ?.
    
    IF  VALID-HANDLE(h-bocx110) THEN
        DELETE PROCEDURE h-bocx110.
    ASSIGN h-bocx110 = ?.
    
    IF  VALID-HANDLE(h-bocx341) THEN
        DELETE PROCEDURE h-bocx341.
    ASSIGN h-bocx341 = ?.
    
    IF  VALID-HANDLE(h-boin295desc) THEN
        DELETE PROCEDURE h-boin295desc.
    ASSIGN h-boin295desc = ?.
    
    IF  VALID-HANDLE(h-boun005) THEN
        DELETE PROCEDURE h-boun005.
    ASSIGN h-boun005 = ?.
    
    IF  VALID-HANDLE(h-bocx155) THEN
        DELETE PROCEDURE h-bocx155.
    ASSIGN h-bocx155 = ?.
    
    IF  VALID-HANDLE(h-boad098na) THEN
        DELETE PROCEDURE h-boad098na.
    ASSIGN h-boad098na = ?.
    

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterInitializeInterface wReport 
PROCEDURE afterInitializeInterface :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    

    APPLY "leave":U TO i-cod-desp IN FRAME fPage2.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE beforeInitializeInterface wReport 
PROCEDURE beforeInitializeInterface :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    RUN initializeDBOs IN THIS-PROCEDURE.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE initializeDBOs wReport 
PROCEDURE initializeDBOs :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    IF  NOT VALID-HANDLE(h-boad039) THEN
        RUN adbo/boad039.p PERSISTENT SET h-boad039.         /*BO cond-pagto*/

    IF  NOT VALID-HANDLE(h-boad259) THEN
        RUN adbo/boad259.p PERSISTENT SET h-boad259.         /*BO tipo-rec-desp*/

    IF  NOT VALID-HANDLE(h-bocx095) THEN
        RUN cxbo/bocx095.p PERSISTENT SET h-bocx095.         /*BO desp-imp*/

    RUN openQuery IN h-bocx095 (INPUT 1).

    IF  NOT VALID-HANDLE(h-bocx110) THEN
        RUN cxbo/bocx110.p PERSISTENT SET h-bocx110.         /*BO pto-contr*/

    IF  NOT VALID-HANDLE(h-bocx341) THEN
        RUN cxbo/bocx341.p PERSISTENT SET h-bocx341.         /*BO despes-ped-compra*/

    IF  NOT VALID-HANDLE(h-boin295desc) THEN
        RUN inbo/boin295desc.p PERSISTENT SET h-boin295desc. /*BO pedido-compr*/

    IF  NOT VALID-HANDLE(h-boun005) THEN
        RUN unbo/boun005.p PERSISTENT SET h-boun005.         /*BO moeda*/

    /* BO emitente-cex */
    IF  NOT VALID-HANDLE(h-bocx155) THEN
        RUN cxbo/bocx155.p PERSISTENT SET h-bocx155.

    /* BO emitente */
    IF  NOT VALID-HANDLE(h-boad098na) THEN
        RUN adbo/boad098na.p PERSISTENT SET h-boad098na.

    RUN openQueryStatic IN h-boad098na (INPUT "Main":U).

    &IF '{&mgdis_version}' < '2.06f' &THEN
        /*Tecnica para implementar valida‡Æo produto Estendido*/
        {cdp/cdapi558.i1}
    &endif
    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-abre-arquivo wReport 
PROCEDURE pi-abre-arquivo :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    {report/rpexc.i}

    SESSION:SET-WAIT-STATE("":U).

    DEFINE VARIABLE c-arquivo AS CHARACTER NO-UNDO.
    DEFINE VARIABLE c-key-value AS CHARACTER NO-UNDO.

    GET-KEY-VALUE SECTION "Datasul_EMS2":U KEY "Show-Report-Program":U VALUE c-key-value.

    IF c-key-value = "":U OR c-key-value = ? THEN DO:
        ASSIGN c-key-value = "Notepad.exe":U.
        PUT-KEY-VALUE SECTION "Datasul_EMS2":U KEY "Show-Report-Program":U VALUE c-key-value NO-ERROR.
    END.
    
    ASSIGN c-arquivo = SESSION:TEMP-DIRECTORY + "im0017" + ".lst".

    IF SEARCH("utp/ut-showreport.r") <> ? OR SEARCH("utp/ut-showreport.p") <> ? THEN DO:
        RUN utp/ut-showreport.p (c-arquivo).
    END.
    ELSE DO:
        RUN winexec (INPUT c-key-value + chr(32) + SESSION:TEMP-DIRECTORY + "im0017.lst", INPUT 1).
    END.
    {&OPEN-QUERY-{&BROWSE-NAME}}

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-incoterm wReport 
PROCEDURE pi-incoterm :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    /* Definicao de Variaveis */
    DEFINE VARIABLE c-retorno      AS CHARACTER NO-UNDO.
    DEFINE VARIABLE i-tipo-despesa AS INTEGER   NO-UNDO.

    ASSIGN i-tipo-despesa = 0.

    RUN findCodigo IN h-bocx095 (INPUT  INPUT FRAME fPage2 i-cod-desp, OUTPUT c-retorno).

    /* Retorno OK? */
    IF  c-retorno = "":U THEN DO:
        /* Buscar Tipo da Despesa */
        RUN getIntField IN h-bocx095 (INPUT "tipo":U, OUTPUT i-tipo-despesa).
    END.

    RUN retornaDespesaImposto IN h-bocx341 (INPUT  0,
                                            INPUT  i-cod-desp:SCREEN-VALUE IN FRAME fPage2,
                                            INPUT  c-cod-estabel,
&IF "{&mguni_version}" >= "2.071" &THEN
                                            INPUT  IF c-cod-estabel = "" THEN "ZZZZZ" ELSE c-cod-estabel,
&ELSE
                                            INPUT  IF c-cod-estabel = "" THEN "ZZZ" ELSE c-cod-estabel,
&ENDIF
                                            INPUT  2,
                                            OUTPUT l-imposto).

    IF  NOT l-imposto      /* Despesa <> Imposto */  AND
       (i-tipo-despesa = 1 /* Valor Fixo         */  OR
        i-tipo-despesa = 2 /* Valor Informado    */  OR
        i-tipo-despesa = 7 /* Valor Calculado    */) THEN
        ASSIGN c-cod-incoterm-rat:SENSITIVE IN FRAME fPage2 = YES.
    ELSE
        ASSIGN c-cod-incoterm-rat:SENSITIVE IN FRAME fPage2    = NO
               c-cod-incoterm-rat:SCREEN-VALUE IN FRAME fPage2 = "":U.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-leaveDespesa wReport 
PROCEDURE pi-leaveDespesa :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    /* Definicao de Variaveis */
    DEFINE VARIABLE c-retorno AS CHARACTER NO-UNDO.

    ASSIGN c-retorno = "":U.

    /* Descricao da Despesa */
    RUN retornaDescDespesa IN h-bocx095 (INPUT  i-cod-desp:SCREEN-VALUE IN FRAME fPage2,
                                         OUTPUT c-desc-desp).

    DISPLAY c-desc-desp WITH FRAME fPage2.

    /* Retornar Valores Padrao da Despesa */
    RUN findCodigo IN h-bocx095 (INPUT  INPUT FRAME fPage2 i-cod-desp,
                                 OUTPUT c-retorno).

    /* Retorno OK? */
    IF  c-retorno = "":U THEN DO:
        RUN getIntField  IN h-bocx095 (INPUT "cod-emitente":U    , OUTPUT i-cod-emitente-desp).
        RUN getIntField  IN h-bocx095 (INPUT "tp-despesa":U      , OUTPUT i-tp-despesa).
        RUN getCharField IN h-bocx095 (INPUT "cod-incoterm-rat":U, OUTPUT c-cod-incoterm-rat).

        IF  i-cod-emitente-desp <> 0 THEN DO:
            RUN findPk-emitente IN h-bocx155 (INPUT  i-cod-emitente-desp,
                                              OUTPUT c-retorno).

            IF  c-retorno = "":U THEN DO:
                RUN getIntField IN h-bocx155 (INPUT "cod-pto-contr":U, OUTPUT i-cod-pto-contr).
            END.

            RUN goToKey IN h-boad098na (INPUT i-cod-emitente-desp).

            IF  RETURN-VALUE = "OK":U THEN DO:
                RUN getIntField IN h-boad098na (INPUT "cod-cond-pag":U, OUTPUT i-cod-cond-pag).

                /* Se o Tipo for Invalido, buscar do Emitente */
                IF  i-tp-despesa = 0 OR
                    i-tp-despesa = ? THEN DO:
                    RUN getIntField IN h-boad098na (INPUT "tp-desp-padrao":U, OUTPUT i-tp-despesa).
                END.
            END.
        END.

        DISPLAY i-cod-emitente-desp
                i-cod-cond-pag
                i-cod-pto-contr
                i-tp-despesa
                c-cod-incoterm-rat WITH FRAME fPage2.

        APPLY "leave":U TO i-cod-emitente-desp IN FRAME fPage2.
        APPLY "leave":U TO i-mo-codigo         IN FRAME fPage2.
        APPLY "leave":U TO i-cod-cond-pag      IN FRAME fPage2.
        APPLY "leave":U TO i-cod-pto-contr     IN FRAME fPage2.
        APPLY "leave":U TO i-tp-despesa        IN FRAME fPage2.
    END.

    APPLY "value-changed":U TO rs-opcao IN FRAME fPage2.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-registrarErro wReport 
PROCEDURE pi-registrarErro :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    FOR EACH RowErrors:
        IF  NOT CAN-FIND (FIRST tt-erro
                          WHERE tt-erro.descricao = RowErrors.ErrorDescription) THEN DO:
            CREATE tt-erro.
            ASSIGN tt-erro.codigo    = RowErrors.ErrorNumber
                   tt-erro.descricao = RowErrors.ErrorDescription.

            CASE RowErrors.ErrorSubType:
                WHEN "ERROR":U   THEN ASSIGN tt-erro.tipo = c-erro.
                WHEN "WARNING":U THEN ASSIGN tt-erro.tipo = c-advertencia.
            END CASE.
        END.
    END.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-retorno wReport 
PROCEDURE pi-retorno :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    
    APPLY "ENTRY" TO i-cod-desp IN FRAME fPage2.
    RETURN NO-APPLY.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piExecute wReport 
PROCEDURE piExecute :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    IF NOT CAN-FIND(FIRST tt-pedido WHERE tt-pedido.marca = YES) THEN DO:
        RUN utp/ut-msgs.p (INPUT "Show":U, 
                           INPUT 30235,
                           INPUT "").
        RETURN NO-APPLY.
    END.

    SESSION:SET-WAIT-STATE("GENERAL":U).
    
    EMPTY TEMP-TABLE tt-despesa.
    EMPTY TEMP-TABLE tt-erro.
    EMPTY TEMP-TABLE tt-desp-param.
    FOR EACH tt-pedido:
        ASSIGN tt-pedido.log-execucao-OK = NO
               tt-pedido.val-desp        = 0.
    END.
    
    CREATE tt-despesa.
    ASSIGN tt-despesa.cod-desp          = INPUT FRAME fPage2 i-cod-desp
           tt-despesa.desc-desp         = INPUT FRAME fPage2 c-desc-desp
           tt-despesa.cod-emitente-desp = INPUT FRAME fPage2 i-cod-emitente-desp
           tt-despesa.desc-emitente     = INPUT FRAME fPage2 c-desc-emit
           tt-despesa.mo-codigo         = INPUT FRAME fPage2 i-mo-codigo
           tt-despesa.desc-moeda        = INPUT FRAME fPage2 c-desc-moeda
           tt-despesa.cod-cond-pag      = INPUT FRAME fPage2 i-cod-cond-pag
           tt-despesa.desc-cond-pag     = INPUT FRAME fPage2 c-desc-cond-pagto
           tt-despesa.cod-pto-contr     = INPUT FRAME fPage2 i-cod-pto-contr
           tt-despesa.desc-pto-contr    = INPUT FRAME fPage2 c-desc-pto-contr
           tt-despesa.tp-despesa        = INPUT FRAME fPage2 i-tp-despesa
           tt-despesa.desc-tipo-despesa = INPUT FRAME fPage2 c-desc-tipo-despesa
           tt-despesa.cod-incoterm-rat  = INPUT FRAME fPage2 c-cod-incoterm-rat
           tt-despesa.val-desp          = INPUT FRAME fPage2 de-val-desp
           tt-despesa.opcao             = INPUT FRAME fPage2 rs-opcao.

    CREATE tt-desp-param.
    ASSIGN tt-desp-param.cod-desp          = tt-despesa.cod-desp
           tt-desp-param.val-desp          = tt-despesa.val-desp
           tt-desp-param.mo-codigo         = tt-despesa.mo-codigo
           tt-desp-param.cod-emitente-desp = tt-despesa.cod-emitente-desp
           tt-desp-param.cod-cond-pag      = tt-despesa.cod-cond-pag
           tt-desp-param.cod-pto-contr     = tt-despesa.cod-pto-contr
           tt-desp-param.cod-incoterm-rat  = tt-despesa.cod-incoterm-rat
           tt-desp-param.tp-despesa        = tt-despesa.tp-despesa.

    IF  tt-despesa.opcao = 1 THEN DO:
        FOR EACH  tt-pedido EXCLUSIVE-LOCK
            WHERE tt-pedido.marca = YES:
    
            RUN emptyRowErrors   IN h-bocx341.
            EMPTY TEMP-TABLE tt-despes-ped-compra.
            RUN openQueryStatic  IN h-bocx341 (INPUT "Main":U).
            RUN sugereSeqDespesa IN h-bocx341 (INPUT  tt-pedido.num-pedido,
                                               OUTPUT i-sequencia).

            CREATE tt-despes-ped-compra.
            ASSIGN tt-despes-ped-compra.num-pedido        = tt-pedido.num-pedido
                   tt-despes-ped-compra.sequencia         = i-sequencia
                   tt-despes-ped-compra.cod-desp          = tt-despesa.cod-desp
                   tt-despes-ped-compra.cod-emitente-desp = tt-despesa.cod-emitente-desp
                   tt-despes-ped-compra.mo-codigo         = tt-despesa.mo-codigo
                   tt-despes-ped-compra.cod-cond-pag      = tt-despesa.cod-cond-pag
                   tt-despes-ped-compra.cod-pto-contr     = tt-despesa.cod-pto-contr
                   tt-despes-ped-compra.tp-despesa        = tt-despesa.tp-despesa
                   tt-despes-ped-compra.cod-incoterm-rat  = tt-despesa.cod-incoterm-rat
                   tt-despes-ped-compra.val-desp          = tt-despesa.val-desp
                   tt-despes-ped-compra.log-despes-ped    = YES. /* Despesa criada no pedido*/

            RUN setRecord      IN h-bocx341 (INPUT TABLE tt-despes-ped-compra).
            RUN validateRecord IN h-bocx341 (INPUT "Create").

            IF  RETURN-VALUE = "NOK" THEN DO:
                RUN getRowErrors     IN h-bocx341 (OUTPUT TABLE RowErrors).
                RUN pi-registrarErro IN THIS-PROCEDURE.
            END.
            ELSE DO:
                RUN createRecord IN h-bocx341.
                ASSIGN tt-pedido.log-execucao-OK = YES.
            END.
        END.
    END.
    ELSE DO:
        IF  tt-despesa.opcao = 2 THEN DO:
    
            DEFINE BUFFER bf-despes-ped-compra FOR despes-ped-compra.
    
            ASSIGN l-despesa-disponivel = NO.
    
            FOR EACH  tt-pedido EXCLUSIVE-LOCK
                WHERE tt-pedido.marca = YES:

                FOR EACH  bf-despes-ped-compra 
                    WHERE bf-despes-ped-compra.num-pedido = tt-pedido.num-pedido                                                                  AND
                          bf-despes-ped-compra.cod-desp   = tt-despesa.cod-desp                                                                   AND
                          IF tt-despesa.cod-emitente-desp = ? THEN YES ELSE bf-despes-ped-compra.cod-emitente-desp = tt-despesa.cod-emitente-desp AND
                          IF tt-despesa.mo-codigo         = ? THEN YES ELSE bf-despes-ped-compra.mo-codigo         = tt-despesa.mo-codigo         AND
                          IF tt-despesa.cod-cond-pag      = ? THEN YES ELSE bf-despes-ped-compra.cod-cond-pag      = tt-despesa.cod-cond-pag      AND
                          IF tt-despesa.cod-pto-contr     = ? THEN YES ELSE bf-despes-ped-compra.cod-pto-contr     = tt-despesa.cod-pto-contr     AND
                          IF tt-despesa.tp-despesa        = ? THEN YES ELSE bf-despes-ped-compra.tp-despesa        = tt-despesa.tp-despesa        NO-LOCK:
    
                    ASSIGN l-despesa-disponivel = YES
                           tt-despesa.val-desp  = bf-despes-ped-compra.val-desp
                           tt-pedido.val-desp   = bf-despes-ped-compra.val-desp. 
    
                    RUN emptyRowErrors   IN h-bocx341.
                    RUN openQueryStatic  IN h-bocx341 (INPUT "Main":U).
                    RUN repositionRecord IN h-bocx341 (INPUT ROWID(bf-despes-ped-compra)).
                    RUN validateRecord   IN h-bocx341 (INPUT "Delete").
    
                    IF  RETURN-VALUE = "NOK" THEN DO:
                        RUN getRowErrors IN h-bocx341 (OUTPUT TABLE RowErrors).
                        RUN pi-registrarErro IN THIS-PROCEDURE.
                    END.
                    ELSE DO:
                        RUN deleteRecord IN h-bocx341.
                        ASSIGN tt-pedido.log-execucao-OK = YES.
                    END.
                END.
            END.
    
            /* Nenhuma Despesa encontrada? */
            IF  NOT l-despesa-disponivel THEN DO:
                CREATE tt-erro.
                /* Inicio -- Projeto Internacional */
                {utp/ut-liter.i "Erro" *}
                ASSIGN tt-erro.codigo = 2864
                       tt-erro.tipo   = RETURN-VALUE.
    
                /* Inicio -- Projeto Internacional */
                DEFINE VARIABLE c-lbl-liter-despesa AS CHARACTER NO-UNDO.
                {utp/ut-liter.i "Despesa" *}
                ASSIGN c-lbl-liter-despesa = TRIM(RETURN-VALUE).
                DEFINE VARIABLE c-lbl-liter-os-pedidos-informados AS CHARACTER NO-UNDO.
                {utp/ut-liter.i "os_pedidos_informados" *}
                ASSIGN c-lbl-liter-os-pedidos-informados = TRIM(RETURN-VALUE).
                RUN utp/ut-msgs.p (INPUT "MSG":U, INPUT 2864, INPUT c-lbl-liter-despesa + "~~" + c-lbl-liter-os-pedidos-informados).
                ASSIGN tt-erro.descricao = RETURN-VALUE.
            END.
        END.
    END.

    FOR EACH  tt-pedido EXCLUSIVE-LOCK
        WHERE tt-pedido.marca = YES:
        
        /* Se processamento NOK, ignorar Pedido */
        IF  NOT tt-pedido.log-execucao-OK THEN
            NEXT.

        EMPTY TEMP-TABLE tt-num-pedidos.
        ASSIGN l-imposto = NO.

        CREATE tt-num-pedidos.
        ASSIGN tt-num-pedidos.num-pedido = tt-pedido.num-pedido.

        RUN retornaDespesaImposto IN h-bocx341 (INPUT  tt-pedido.num-pedido,
                                                INPUT  tt-despesa.cod-desp,
                                                INPUT  "",
                                                INPUT  "",
                                                INPUT  1,
                                                OUTPUT l-imposto).

        IF  INPUT FRAME fPage2 rs-opcao = 1 THEN DO:
            RUN atualizaDespesasOrdem IN h-bocx341 (INPUT 1,
                                                    INPUT ?,
                                                    INPUT ?,
                                                    INPUT ?,
                                                    INPUT ?,
                                                    INPUT TABLE tt-desp-param,
                                                    INPUT TABLE tt-num-pedidos).
            IF l-imposto THEN DO:
                RUN retornaValorDespesa IN h-bocx341 (INPUT tt-pedido.num-pedido, 
                                                      INPUT tt-despesa.cod-desp,
                                                      INPUT tt-despesa.mo-codigo,
                                                      INPUT tt-despesa.cod-emitente-desp,
                                                      INPUT tt-despesa.cod-cond-pag,
                                                      INPUT tt-despesa.cod-pto-contr,
                                                      INPUT tt-despesa.tp-despesa,
                                                     OUTPUT rw-despes-ped-compra,
                                                     OUTPUT de-val-desp).
                ASSIGN tt-despesa.val-desp = de-val-desp
                       tt-pedido.val-desp  = de-val-desp.
            END.
        END.
        ELSE
            RUN atualizaDespesasOrdem IN h-bocx341 (INPUT 3,
                                                    INPUT ?,
                                                    INPUT ?,
                                                    INPUT ?,
                                                    INPUT ?,
                                                    INPUT TABLE tt-desp-param,
                                                    INPUT TABLE tt-num-pedidos).
    END.

    RUN imp/im0017rp.p (INPUT TABLE tt-pedido,
                        INPUT TABLE tt-despesa,
                        INPUT TABLE tt-erro,
                        INPUT l-imposto).

    RUN pi-abre-arquivo.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setSelecao wReport 
PROCEDURE setSelecao :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE INPUT PARAMETER TABLE FOR tt-param.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setTempTable wReport 
PROCEDURE setTempTable :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER TABLE FOR tt-pedido.
    DEFINE INPUT PARAMETER pCod-estabel AS CHARACTER NO-UNDO.

    ASSIGN c-cod-estabel = pCod-estabel.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

