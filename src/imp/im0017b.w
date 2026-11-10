&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          mgadm            PROGRESS
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
{include/i-prgvrs.i IM0017B 2.00.00.006}  /*** 010006 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i im0017b MIM}
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
&GLOBAL-DEFINE Program        IM0017B
&GLOBAL-DEFINE Version        2.00.00.006

&GLOBAL-DEFINE WindowType     Master/Detail

&GLOBAL-DEFINE Folder         NO
&GLOBAL-DEFINE InitialPage    1
&GLOBAL-DEFINE FolderLabels   

&GLOBAL-DEFINE page0Widgets   btOK btCancel btHelp2
&GLOBAL-DEFINE page1Widgets   c-cod-estabel i-num-pedido-ini i-num-pedido-fim data-pedido-ini ~
                              data-pedido-fim i-via-transp-ini i-via-transp-fim i-cod-transp-ini ~
                              i-cod-transp-fim i-exportador-ini i-exportador-fim c-nr-proc-imp-ini ~
                              c-nr-proc-imp-fim c-incoterm-ini c-incoterm-fim i-cod-itiner-ini ~
                              i-cod-itiner-fim i-cod-despachante-ini i-cod-despachante-fim i-cdn-despa-exter-import-ini ~
                              i-cdn-despa-exter-import-fim i-cdn-corretor-cambio-import-ini i-cdn-corretor-cambio-import-fim ~
                              i-cod-agente-ini i-cod-agente-fim i-cdn-segurad-import-ini i-cdn-segurad-import-fim ~
                              i-cdn-corretor-import-ini i-cdn-corretor-import-fim c-it-codigo-ini c-it-codigo-fim

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

DEFINE INPUT PARAMETER h-im0017a AS HANDLE NO-UNDO.
/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fpage0

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS btOK btCancel btHelp2 rtToolBar 

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

DEFINE VARIABLE i-via-transp-fim AS CHARACTER FORMAT "X(256)" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "Item 1" 
     DROP-DOWN-LIST
     SIZE 16 BY 1 NO-UNDO.

DEFINE VARIABLE i-via-transp-ini AS CHARACTER FORMAT "X(256)" 
     LABEL "Via Transporte":R17 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "Item 1" 
     DROP-DOWN-LIST
     SIZE 16 BY 1 NO-UNDO.

DEFINE VARIABLE c-cod-estabel LIKE estabelec.cod-estabel
     LABEL "Estab":R7 
     VIEW-AS FILL-IN 
     SIZE 7.14 BY .88 NO-UNDO.

DEFINE VARIABLE c-incoterm-fim AS CHARACTER FORMAT "X(03)":U INITIAL "ZZZ" 
     VIEW-AS FILL-IN 
     SIZE 4 BY .88 NO-UNDO.

DEFINE VARIABLE c-incoterm-ini AS CHARACTER FORMAT "X(03)":U 
     LABEL "Incoterm" 
     VIEW-AS FILL-IN 
     SIZE 4 BY .88 NO-UNDO.

DEFINE VARIABLE c-it-codigo-fim AS CHARACTER FORMAT "X(16)":U INITIAL "ZZZZZZZZZZZZZZZZ" 
     VIEW-AS FILL-IN 
     SIZE 18 BY .88 NO-UNDO.

DEFINE VARIABLE c-it-codigo-ini AS CHARACTER FORMAT "X(16)":U 
     LABEL "Item" 
     VIEW-AS FILL-IN 
     SIZE 17 BY .88 NO-UNDO.

DEFINE VARIABLE c-nr-proc-imp-fim AS CHARACTER FORMAT "X(12)" INITIAL "ZZZZZZZZZZZZ" 
     VIEW-AS FILL-IN 
     SIZE 13 BY .88.

DEFINE VARIABLE c-nr-proc-imp-ini AS CHARACTER FORMAT "X(12)" 
     LABEL "Processo Importa‡Æo":R19 
     VIEW-AS FILL-IN 
     SIZE 13 BY .88.

DEFINE VARIABLE data-pedido-fim AS DATE FORMAT "99/99/9999" INITIAL 12/31/9999 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88 NO-UNDO.

DEFINE VARIABLE data-pedido-ini AS DATE FORMAT "99/99/9999" INITIAL &IF "{&ems_dbtype}":U = "MSS":U &THEN 01/01/1800 &ELSE 01/01/001  &ENDIF 
     LABEL "Data Pedido":R14 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88 NO-UNDO.

DEFINE VARIABLE i-cdn-corretor-cambio-import-fim AS INTEGER FORMAT ">>>>>>>>9" INITIAL 999999999 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88.

DEFINE VARIABLE i-cdn-corretor-cambio-import-ini AS INTEGER FORMAT ">>>>>>>>9" INITIAL 0 
     LABEL "Corretor Cƒmbio":R20 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88.

DEFINE VARIABLE i-cdn-corretor-import-fim AS INTEGER FORMAT ">>>>>>>>9" INITIAL 999999999 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88.

DEFINE VARIABLE i-cdn-corretor-import-ini AS INTEGER FORMAT ">>>>>>>>9" INITIAL 0 
     LABEL "Corretor de Seguros":R20 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88.

DEFINE VARIABLE i-cdn-despa-exter-import-fim AS INTEGER FORMAT ">>>>>>>>9" INITIAL 999999999 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88.

DEFINE VARIABLE i-cdn-despa-exter-import-ini AS INTEGER FORMAT ">>>>>>>>9" INITIAL 0 
     LABEL "Despachante Exterior":R20 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88.

DEFINE VARIABLE i-cdn-segurad-import-fim AS INTEGER FORMAT ">>>>>>>>9" INITIAL 999999999 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88.

DEFINE VARIABLE i-cdn-segurad-import-ini AS INTEGER FORMAT ">>>>>>>>9" INITIAL 0 
     LABEL "Seguradora":R20 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88.

DEFINE VARIABLE i-cod-agente-fim AS INTEGER FORMAT ">>>>>>>>9" INITIAL 999999999 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88.

DEFINE VARIABLE i-cod-agente-ini AS INTEGER FORMAT ">>>>>>>>9" INITIAL 0 
     LABEL "Agente Cargas":R20 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88.

DEFINE VARIABLE i-cod-despachante-fim AS INTEGER FORMAT ">>>>>>>>9" INITIAL 999999999 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88.

DEFINE VARIABLE i-cod-despachante-ini AS INTEGER FORMAT ">>>>>>>>9" INITIAL 0 
     LABEL "Despachante":R12 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88.

DEFINE VARIABLE i-cod-itiner-fim AS INTEGER FORMAT ">>,>>9":U INITIAL 99999 
     VIEW-AS FILL-IN 
     SIZE 6 BY .88 NO-UNDO.

DEFINE VARIABLE i-cod-itiner-ini AS INTEGER FORMAT ">>,>>9":U INITIAL 0 
     LABEL "Itiner rio" 
     VIEW-AS FILL-IN 
     SIZE 6 BY .88 NO-UNDO.

DEFINE VARIABLE i-cod-transp-fim AS INTEGER FORMAT ">>,>>9" INITIAL 99999 
     VIEW-AS FILL-IN 
     SIZE 6 BY .88.

DEFINE VARIABLE i-cod-transp-ini AS INTEGER FORMAT ">>,>>9" INITIAL 0 
     LABEL "Transportador":R16 
     VIEW-AS FILL-IN 
     SIZE 6 BY .88.

DEFINE VARIABLE i-exportador-fim AS INTEGER FORMAT ">>>>>>>>9" INITIAL 999999999 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88.

DEFINE VARIABLE i-exportador-ini AS INTEGER FORMAT ">>>>>>>>9" INITIAL 0 
     LABEL "Exportador":R12 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88.

DEFINE VARIABLE i-num-pedido-fim AS INTEGER FORMAT ">>>>>,>>9" INITIAL 99999999 
     VIEW-AS FILL-IN 
     SIZE 8 BY .88 NO-UNDO.

DEFINE VARIABLE i-num-pedido-ini AS INTEGER FORMAT ">>>>>,>>9" INITIAL 0 
     LABEL "Pedido":R8 
     VIEW-AS FILL-IN 
     SIZE 8 BY .88 NO-UNDO.

DEFINE IMAGE IMAGE-10
     FILENAME "image~\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-11
     FILENAME "image~\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-12
     FILENAME "image~\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-13
     FILENAME "image~\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-14
     FILENAME "image~\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-15
     FILENAME "image~\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-16
     FILENAME "image~\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-17
     FILENAME "image~\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-18
     FILENAME "image~\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-19
     FILENAME "image~\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-20
     FILENAME "image~\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-21
     FILENAME "image~\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-22
     FILENAME "image~\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-23
     FILENAME "image~\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-24
     FILENAME "image~\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-25
     FILENAME "image~\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-26
     FILENAME "image~\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-27
     FILENAME "image~\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-28
     FILENAME "image~\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-29
     FILENAME "image~\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-3
     FILENAME "image~\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-30
     FILENAME "image~\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-31
     FILENAME "image~\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-32
     FILENAME "image~\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-33
     FILENAME "image~\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-4
     FILENAME "image~\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-6
     FILENAME "image~\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-7
     FILENAME "image~\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-8
     FILENAME "image~\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-9
     FILENAME "image~\im-las":U
     SIZE 3 BY .88.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fpage0
     btOK AT ROW 18.21 COL 2
     btCancel AT ROW 18.21 COL 13
     btHelp2 AT ROW 18.21 COL 80
     rtToolBar AT ROW 18 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 90 BY 18.42
         FONT 1.

DEFINE FRAME fPage1
     c-cod-estabel AT ROW 1.25 COL 36 COLON-ALIGNED
          LABEL "Estab":R7
     i-num-pedido-ini AT ROW 2.25 COL 32 COLON-ALIGNED HELP
          "N£mero do Pedido de Compra"
     i-num-pedido-fim AT ROW 2.25 COL 52 COLON-ALIGNED HELP
          "N£mero do Pedido de Compra" NO-LABEL
     data-pedido-ini AT ROW 3.25 COL 30 COLON-ALIGNED
     data-pedido-fim AT ROW 3.25 COL 52 COLON-ALIGNED NO-LABEL
     i-via-transp-ini AT ROW 4.25 COL 24 COLON-ALIGNED HELP
          "Via Transporte"
     i-via-transp-fim AT ROW 4.25 COL 52 COLON-ALIGNED HELP
          "Via Transporte" NO-LABEL
     i-cod-transp-ini AT ROW 5.25 COL 34 COLON-ALIGNED
     i-cod-transp-fim AT ROW 5.25 COL 52 COLON-ALIGNED NO-LABEL
     i-exportador-ini AT ROW 6.25 COL 30 COLON-ALIGNED
     i-exportador-fim AT ROW 6.25 COL 52 COLON-ALIGNED NO-LABEL
     c-nr-proc-imp-ini AT ROW 7.25 COL 27 COLON-ALIGNED
     c-nr-proc-imp-fim AT ROW 7.25 COL 52 COLON-ALIGNED NO-LABEL
     c-incoterm-ini AT ROW 8.25 COL 36 COLON-ALIGNED
     c-incoterm-fim AT ROW 8.25 COL 52 COLON-ALIGNED NO-LABEL
     i-cod-itiner-ini AT ROW 9.25 COL 34 COLON-ALIGNED
     i-cod-itiner-fim AT ROW 9.25 COL 52 COLON-ALIGNED NO-LABEL
     i-cod-despachante-ini AT ROW 10.25 COL 30 COLON-ALIGNED
     i-cod-despachante-fim AT ROW 10.25 COL 52 COLON-ALIGNED NO-LABEL
     i-cdn-despa-exter-import-ini AT ROW 11.25 COL 30 COLON-ALIGNED
     i-cdn-despa-exter-import-fim AT ROW 11.25 COL 52 COLON-ALIGNED NO-LABEL
     i-cdn-corretor-cambio-import-ini AT ROW 12.25 COL 30 COLON-ALIGNED
     i-cdn-corretor-cambio-import-fim AT ROW 12.25 COL 52 COLON-ALIGNED NO-LABEL
     i-cod-agente-ini AT ROW 13.25 COL 30 COLON-ALIGNED
     i-cod-agente-fim AT ROW 13.25 COL 52 COLON-ALIGNED NO-LABEL
     i-cdn-segurad-import-ini AT ROW 14.25 COL 30 COLON-ALIGNED
     i-cdn-segurad-import-fim AT ROW 14.25 COL 52 COLON-ALIGNED NO-LABEL
     i-cdn-corretor-import-ini AT ROW 15.25 COL 30 COLON-ALIGNED
     i-cdn-corretor-import-fim AT ROW 15.25 COL 52 COLON-ALIGNED NO-LABEL
     c-it-codigo-ini AT ROW 16.25 COL 23 COLON-ALIGNED
     c-it-codigo-fim AT ROW 16.25 COL 52 COLON-ALIGNED NO-LABEL
     IMAGE-10 AT ROW 5.25 COL 43
     IMAGE-11 AT ROW 5.25 COL 50
     IMAGE-12 AT ROW 6.25 COL 43
     IMAGE-13 AT ROW 6.25 COL 50
     IMAGE-14 AT ROW 7.25 COL 43
     IMAGE-15 AT ROW 7.25 COL 50
     IMAGE-16 AT ROW 8.25 COL 43
     IMAGE-17 AT ROW 8.25 COL 50
     IMAGE-18 AT ROW 9.25 COL 43
     IMAGE-19 AT ROW 9.25 COL 50
     IMAGE-20 AT ROW 10.25 COL 43
     IMAGE-21 AT ROW 10.25 COL 50
     IMAGE-22 AT ROW 11.25 COL 43
     IMAGE-23 AT ROW 11.25 COL 50
     IMAGE-24 AT ROW 12.25 COL 43
     IMAGE-25 AT ROW 12.25 COL 50
     IMAGE-26 AT ROW 13.25 COL 43
     IMAGE-27 AT ROW 13.25 COL 50
     IMAGE-28 AT ROW 14.25 COL 43
     IMAGE-29 AT ROW 14.25 COL 50
     IMAGE-3 AT ROW 2.25 COL 43
     IMAGE-30 AT ROW 15.25 COL 43
     IMAGE-31 AT ROW 15.25 COL 50
     IMAGE-32 AT ROW 16.25 COL 43
     IMAGE-33 AT ROW 16.25 COL 50
     IMAGE-4 AT ROW 2.25 COL 50
     IMAGE-6 AT ROW 3.25 COL 43
     IMAGE-7 AT ROW 3.25 COL 50
     IMAGE-8 AT ROW 4.25 COL 43
     IMAGE-9 AT ROW 4.25 COL 50
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 2 ROW 1.25
         SIZE 88 BY 16.5
         FONT 1.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Window
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW wWindow ASSIGN
         HIDDEN             = YES
         TITLE              = ""
         HEIGHT             = 18.42
         WIDTH              = 90
         MAX-HEIGHT         = 18.42
         MAX-WIDTH          = 90
         VIRTUAL-HEIGHT     = 18.42
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
/* REPARENT FRAME */
ASSIGN FRAME fPage1:FRAME = FRAME fpage0:HANDLE.

/* SETTINGS FOR FRAME fpage0
   FRAME-NAME                                                           */
/* SETTINGS FOR FRAME fPage1
                                                                        */
/* SETTINGS FOR FILL-IN c-cod-estabel IN FRAME fPage1
   LIKE = mgadm.estabelec.cod-estabel EXP-LABEL EXP-SIZE                */
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
  RUN pi-retorno IN h-im0017a.
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btCancel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btCancel wWindow
ON CHOOSE OF btCancel IN FRAME fpage0 /* Cancelar */
DO:
    RUN pi-retorno IN h-im0017a.
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
    FIND FIRST tt-param NO-LOCK NO-ERROR.
    IF NOT AVAILABLE tt-param THEN
        CREATE tt-param.

    ASSIGN tt-param.cod-estabel                    = INPUT FRAME fPage1 c-cod-estabel
           tt-param.num-pedido-ini                 = INPUT FRAME fPage1 i-num-pedido-ini
           tt-param.num-pedido-fim                 = INPUT FRAME fPage1 i-num-pedido-fim
           tt-param.data-pedido-ini                = INPUT FRAME fPage1 data-pedido-ini
           tt-param.data-pedido-fim                = INPUT FRAME fPage1 data-pedido-fim
           tt-param.cod-transp-ini                 = INPUT FRAME fPage1 i-cod-transp-ini
           tt-param.cod-transp-fim                 = INPUT FRAME fPage1 i-cod-transp-fim
           tt-param.cod-emitente-ini               = INPUT FRAME fPage1 i-exportador-ini
           tt-param.cod-emitente-fim               = INPUT FRAME fPage1 i-exportador-fim
           tt-param.nr-proc-imp-ini                = INPUT FRAME fPage1 c-nr-proc-imp-ini
           tt-param.nr-proc-imp-fim                = INPUT FRAME fPage1 c-nr-proc-imp-fim
           tt-param.incoterm-ini                   = INPUT FRAME fPage1 c-incoterm-ini
           tt-param.incoterm-fim                   = INPUT FRAME fPage1 c-incoterm-fim
           tt-param.cod-itiner-ini                 = INPUT FRAME fPage1 i-cod-itiner-ini
           tt-param.cod-itiner-fim                 = INPUT FRAME fPage1 i-cod-itiner-fim
           tt-param.cod-despachante-ini            = INPUT FRAME fPage1 i-cod-despachante-ini
           tt-param.cod-despachante-fim            = INPUT FRAME fPage1 i-cod-despachante-fim
           tt-param.cdn-despa-exter-import-ini     = INPUT FRAME fPage1 i-cdn-despa-exter-import-ini
           tt-param.cdn-despa-exter-import-fim     = INPUT FRAME fPage1 i-cdn-despa-exter-import-fim
           tt-param.cdn-corretor-cambio-import-ini = INPUT FRAME fPage1 i-cdn-corretor-cambio-import-ini
           tt-param.cdn-corretor-cambio-import-fim = INPUT FRAME fPage1 i-cdn-corretor-cambio-import-fim
           tt-param.cod-agente-ini                 = INPUT FRAME fPage1 i-cod-agente-ini
           tt-param.cod-agente-fim                 = INPUT FRAME fPage1 i-cod-agente-fim
           tt-param.cdn-segurad-import-ini         = INPUT FRAME fPage1 i-cdn-segurad-import-ini
           tt-param.cdn-segurad-import-fim         = INPUT FRAME fPage1 i-cdn-segurad-import-fim
           tt-param.cdn-corretor-import-ini        = INPUT FRAME fPage1 i-cdn-corretor-import-ini
           tt-param.cdn-corretor-import-fim        = INPUT FRAME fPage1 i-cdn-corretor-import-fim
           tt-param.it-codigo-ini                  = INPUT FRAME fPage1 c-it-codigo-ini
           tt-param.it-codigo-fim                  = INPUT FRAME fPage1 c-it-codigo-fim.

    ASSIGN tt-param.via-transp-ini = {adinc/i01ad268.i 06 i-via-transp-ini:SCREEN-VALUE IN FRAME fPage1}
           tt-param.via-transp-fim = {adinc/i01ad268.i 06 i-via-transp-fim:SCREEN-VALUE IN FRAME fPage1}.


    IF CAN-FIND(FIRST tt-pedido WHERE tt-pedido.marca = YES) THEN DO:
        RUN utp/ut-msgs.p (INPUT "SHOW":U, 
                           INPUT 29405, 
                           INPUT "").

        IF RETURN-VALUE = "YES" THEN DO:
            EMPTY TEMP-TABLE tt-pedido.
            RUN imp/im0017b1.p (INPUT  TABLE tt-param,
                               INPUT-OUTPUT TABLE tt-pedido).
        END.
    END.
    ELSE DO:
        EMPTY TEMP-TABLE tt-pedido.
        RUN imp/im0017b1.p (INPUT  TABLE tt-param,
                           INPUT-OUTPUT TABLE tt-pedido).
    END.

    RUN setSelecao   IN h-im0017a(INPUT TABLE tt-param).
    RUN setTempTable IN h-im0017a(INPUT TABLE tt-pedido,
                                  INPUT INPUT FRAME fPage1 c-cod-estabel).

    RUN pi-retorno IN h-im0017a.
    APPLY "CLOSE":U TO THIS-PROCEDURE.                
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

    FIND FIRST tt-param NO-LOCK NO-ERROR.
    IF AVAILABLE tt-param THEN DO:
        ASSIGN c-cod-estabel:SCREEN-VALUE IN FRAME fPage1                    = tt-param.cod-estabel                   
               i-num-pedido-ini:SCREEN-VALUE IN FRAME fPage1                 = string(tt-param.num-pedido-ini)                
               i-num-pedido-fim:SCREEN-VALUE IN FRAME fPage1                 = string(tt-param.num-pedido-fim)                
               data-pedido-ini:SCREEN-VALUE IN FRAME fPage1                  = string(tt-param.data-pedido-ini)
               data-pedido-fim:SCREEN-VALUE IN FRAME fPage1                  = string(tt-param.data-pedido-fim)
               i-cod-transp-ini:SCREEN-VALUE IN FRAME fPage1                 = string(tt-param.cod-transp-ini)                
               i-cod-transp-fim:SCREEN-VALUE IN FRAME fPage1                 = string(tt-param.cod-transp-fim)                
               i-exportador-ini:SCREEN-VALUE IN FRAME fPage1                 = string(tt-param.cod-emitente-ini)              
               i-exportador-fim:SCREEN-VALUE IN FRAME fPage1                 = string(tt-param.cod-emitente-fim)              
               c-nr-proc-imp-ini:SCREEN-VALUE IN FRAME fPage1                = tt-param.nr-proc-imp-ini               
               c-nr-proc-imp-fim:SCREEN-VALUE IN FRAME fPage1                = tt-param.nr-proc-imp-fim               
               c-incoterm-ini:SCREEN-VALUE IN FRAME fPage1                   = tt-param.incoterm-ini                  
               c-incoterm-fim:SCREEN-VALUE IN FRAME fPage1                   = tt-param.incoterm-fim                  
               i-cod-itiner-ini:SCREEN-VALUE IN FRAME fPage1                 = string(tt-param.cod-itiner-ini)
               i-cod-itiner-fim:SCREEN-VALUE IN FRAME fPage1                 = string(tt-param.cod-itiner-fim)                
               i-cod-despachante-ini:SCREEN-VALUE IN FRAME fPage1            = string(tt-param.cod-despachante-ini)           
               i-cod-despachante-fim:SCREEN-VALUE IN FRAME fPage1            = string(tt-param.cod-despachante-fim)           
               i-cdn-despa-exter-import-ini:SCREEN-VALUE IN FRAME fPage1     = string(tt-param.cdn-despa-exter-import-ini)    
               i-cdn-despa-exter-import-fim:SCREEN-VALUE IN FRAME fPage1     = string(tt-param.cdn-despa-exter-import-fim)    
               i-cdn-corretor-cambio-import-ini:SCREEN-VALUE IN FRAME fPage1 = string(tt-param.cdn-corretor-cambio-import-ini)
               i-cdn-corretor-cambio-import-fim:SCREEN-VALUE IN FRAME fPage1 = string(tt-param.cdn-corretor-cambio-import-fim)
               i-cod-agente-ini:SCREEN-VALUE IN FRAME fPage1                 = string(tt-param.cod-agente-ini)                
               i-cod-agente-fim:SCREEN-VALUE IN FRAME fPage1                 = string(tt-param.cod-agente-fim)                
               i-cdn-segurad-import-ini:SCREEN-VALUE IN FRAME fPage1         = string(tt-param.cdn-segurad-import-ini)        
               i-cdn-segurad-import-fim:SCREEN-VALUE IN FRAME fPage1         = string(tt-param.cdn-segurad-import-fim)        
               i-cdn-corretor-import-ini:SCREEN-VALUE IN FRAME fPage1        = string(tt-param.cdn-corretor-import-ini)       
               i-cdn-corretor-import-fim:SCREEN-VALUE IN FRAME fPage1        = string(tt-param.cdn-corretor-import-fim)       
               c-it-codigo-ini:SCREEN-VALUE IN FRAME fPage1                  = tt-param.it-codigo-ini                 
               c-it-codigo-fim:SCREEN-VALUE IN FRAME fPage1                  = tt-param.it-codigo-fim
               i-via-transp-ini:SCREEN-VALUE IN FRAME fPage1                 = {adinc/i01ad268.i 04 tt-param.via-transp-ini}
               i-via-transp-fim:SCREEN-VALUE IN FRAME fPage1                 = {adinc/i01ad268.i 04 tt-param.via-transp-fim}.
    END.
    ELSE DO:
        ASSIGN i-via-transp-ini:SCREEN-VALUE IN FRAME fPage1                 = {adinc/i01ad268.i 04 1}
               i-via-transp-fim:SCREEN-VALUE IN FRAME fPage1                 = {adinc/i01ad268.i 04 8}.
    END.

    APPLY "ENTRY" TO c-cod-estabel IN FRAME fPage1.
    RETURN NO-APPLY.

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
    ASSIGN i-via-transp-ini:LIST-ITEMS IN FRAME fPage1 = {adinc/i01ad268.i 03}
           i-via-transp-fim:LIST-ITEMS IN FRAME fPage1 = {adinc/i01ad268.i 03}.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE inputPedidos wWindow 
PROCEDURE inputPedidos :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER TABLE FOR tt-pedido. 

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setSelecao wWindow 
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

